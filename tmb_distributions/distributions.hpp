#include <TMB.hpp>

namespace distributions
{

/* 1.0+8.0*choose(k, 2) must be exactly representable in double precision */
#define CHOOSE_MAX ((1ULL << (DBL_MANT_DIG - 3)) - 1)

template<class Type>
Type mvlgamma(Type x, Eigen::Index n = 1)
{
	if (n <= 0)
	{
		Rf_error("%s: '%s' is non-positive",
		         __func__, "n");
	}
	Type res = Type(0.25 * n * (n - 1) * log(M_PI));
	for (Eigen::Index j = 0; j < n; ++j)
	{
		res += lgamma(x - Type(0.5 * j));
	}
	return res;
}

template<class Type>
Type dlkj(const vector<Type> &x, Type shape, int give_log = 0)
{
	Eigen::Index len = x.size();
	if (len == 0)
	{
		Rf_error("%s: length of '%s' is zero",
		         __func__, "x");
	}
	if (len > CHOOSE_MAX)
	{
		Rf_error("%s: length of '%s' (%lld) exceeds maximum %llu",
		         __func__, "x", static_cast<long long int>(len), CHOOSE_MAX);
	}
	Eigen::Index n = static_cast<Eigen::Index>(0.5 * (1.0 + sqrt(1.0 + 8.0 * len)));
	Type eta_minus_one = exp(shape) - Type(1.0);

	matrix<Type> R(n, n);
	for (Eigen::Index j = 0, k = 0; j < n; ++j)
	{
		for (Eigen::Index i = 0; i < j; ++i, ++k)
		{
			R(i, j) = x(k);
		}
		R(j, j) = Type(1.0);
		for (Eigen::Index i = j + 1; i < n; ++i)
		{
			R(i, j) = Type(0.0);
		}
	}

	Type log_det_X = -(R.array() * R.array()).colwise().sum().log().sum();

	Type log_res = Type(0.0);
	/* Terms from conventional density function : */
	log_res += eta_minus_one * log_det_X +
		Type(M_LN2 * n * (n - 1)) * (eta_minus_one + Type((n + n - 1) / 6.0));
	for (Eigen::Index j = 1; j < n; ++j)
	{
		Type a = Type(2.0) * eta_minus_one + Type(j + 1);
		log_res += Type(2 * j) * lgamma(Type(0.5) * a) - Type(j) * lgamma(a);
	}
	/* Terms from Jacobian determinant : */
	log_res += Type(0.5 * (n + 2)) * log_det_X;
	return (give_log) ? log_res : exp(log_res);
}

template<class Type>
Type dwishart(const vector<Type> &x,
              Type shape,
              const vector<Type> &scale,
              int give_log = 0)
{
#define DWISHART_BODY(X, S, OP) \
	do { \
	Eigen::Index len = x.size(); \
	if (len != scale.size()) \
	{ \
		Rf_error("%s: length of '%s' (%lld) is not equal to length of '%s' (%lld)", \
		         __func__, "x", static_cast<long long int>(len), "scale", static_cast<long long int>(scale.size())); \
	} \
	if (len == 0) \
	{ \
		Rf_error("%s: length of '%s' is zero", \
		         __func__, "x"); \
	} \
	if (len > CHOOSE_MAX) \
	{ \
		Rf_error("%s: length of '%s' (%lld) exceeds maximum %llu", \
		         __func__, "x", static_cast<long long int>(len), CHOOSE_MAX); \
	} \
	Eigen::Index n = static_cast<Eigen::Index>(0.5 * (-1.0 + sqrt(1.0 + 8.0 * len))); \
	Type nu = exp(shape) + Type(n - 1); \
	 \
	vector<Type> half_log_diag_X =     x.head(n); \
	vector<Type> half_log_diag_S = scale.head(n); \
	 \
	Type sum_log_diag_X = Type(2.0) * half_log_diag_X.sum(); \
	Type sum_log_diag_S = Type(2.0) * half_log_diag_S.sum(); \
	 \
	matrix<Type> R_X(n, n); \
	matrix<Type> R_S(n, n); \
	for (Eigen::Index j = 0, k = n; j < n; ++j) \
	{ \
		for (Eigen::Index i = 0; i < j; ++i, ++k) \
		{ \
			R_X(i, j) =     x(k); \
			R_S(i, j) = scale(k); \
		} \
		R_X(j, j) = Type(1.0); \
		R_S(j, j) = Type(1.0); \
		for (Eigen::Index i = j + 1; i < n; ++i) \
		{ \
			R_X(i, j) = Type(0.0); \
			R_S(i, j) = Type(0.0); \
		} \
	} \
	 \
	vector<Type> log_diag_RTR_X = \
		(R_X.array() * R_X.array()).colwise().sum().log(); \
	vector<Type> log_diag_RTR_S = \
		(R_S.array() * R_S.array()).colwise().sum().log(); \
	 \
	Type sum_log_diag_RTR_X = log_diag_RTR_X.sum(); \
	Type sum_log_diag_RTR_S = log_diag_RTR_S.sum(); \
	 \
	Type log_det_X = sum_log_diag_X - sum_log_diag_RTR_X; \
	Type log_det_S = sum_log_diag_S - sum_log_diag_RTR_S; \
	 \
	matrix<Type> inv_R_##S = atomic::matinv(R_##S); \
	matrix<Type> V = (R_##X.transpose() * R_##X).array() * \
		(inv_R_##S * inv_R_##S.transpose()).array(); \
	vector<Type> log_diag_D = half_log_diag_##X - half_log_diag_##S - \
		Type(0.5) * (log_diag_RTR_##X - log_diag_RTR_##S); \
	Type sum_DVD = Type(0.0); \
	/* FIXME: Define an atomic function to compute the sum more robustly  */ \
	/*        as exp(logspace_sub(log_sum_posterms, log_sum_negterms))    */ \
	/*        where computing each log_sum_*terms requires branching on   */ \
	/*        the sign of V(i, j).  That the sum is positive follows from */ \
	/*        the Schur product theorem.                                  */ \
	for (Eigen::Index j = 0; j < n; ++j) \
	{ \
		for (Eigen::Index i = 0; i < j; ++i) \
		{ \
			sum_DVD += Type(2.0) * V(i, j) * exp(log_diag_D(i) + log_diag_D(j)); \
		} \
		sum_DVD += V(j, j) * exp(Type(2.0) * log_diag_D(j)); \
	} \
	 \
	Type log_res = Type(0.0); \
	/* Terms from conventional density function : */ \
	log_res += Type(-0.5) * \
		(OP(nu) * log_det_S + (-OP(nu) + Type(n + 1)) * log_det_X + \
		 nu * Type(n * M_LN2) + Type(2.0) * mvlgamma(Type(0.5) * nu, n) + \
		 sum_DVD); \
	/* Terms from Jacobian determinant : */ \
	log_res += \
		(Type(n * M_LN2) + \
		 Type(0.5 * (n + 1)) * sum_log_diag_X - \
		 Type(0.5 * (n + 2)) * sum_log_diag_RTR_X); \
	return (give_log) ? log_res : exp(log_res); \
	} while (0)
	DWISHART_BODY(X, S, +);
}

template<class Type>
Type dinvwishart(const vector<Type> &x,
                 Type shape,
                 const vector<Type> &scale,
                 int give_log = 0)
{
	DWISHART_BODY(S, X, -);
}

#undef CHOOSE_MAX

} /* namespace distributions */
