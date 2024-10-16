#include "distributions.hpp"

enum test
{
	mvlgamma,
	dlkj,
	dwishart,
	dinvwishart
};

template<class Type>
Type objective_function<Type>::operator()()
{
	DATA_INTEGER(flag);

	switch (flag)
	{
	case mvlgamma:
	{
		DATA_VECTOR(x);
		DATA_INTEGER(n);
		Eigen::Index len = x.size();
		vector<Type> res(len);
		for (Eigen::Index i = 0; i < len; ++i)
		{
			res(i) = distributions::mvlgamma(x(i), n);
		}
		REPORT(res);
		break;
	}
	case dlkj:
	{
		DATA_VECTOR(x);
		DATA_SCALAR(shape);
		DATA_INTEGER(give_log);
		Type res = distributions::dlkj(x, shape, give_log);
		REPORT(res);
		break;
	}
	case dwishart:
	{
		DATA_VECTOR(x);
		DATA_SCALAR(shape);
		DATA_VECTOR(scale);
		DATA_INTEGER(give_log);
		Type res = distributions::dwishart(x, shape, scale, give_log);
		REPORT(res);
		break;
	}
	case dinvwishart:
	{
		DATA_VECTOR(x);
		DATA_SCALAR(shape);
		DATA_VECTOR(scale);
		DATA_INTEGER(give_log);
		Type res = distributions::dinvwishart(x, shape, scale, give_log);
		REPORT(res);
		break;
	}
	}

	return Type(0.0);
}
