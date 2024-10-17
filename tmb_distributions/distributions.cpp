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
	Type res = Type(0.0);
	DATA_INTEGER(flag);
	switch (flag)
	{
	case mvlgamma:
	{
		DATA_SCALAR(x);
		DATA_INTEGER(n);
		res = distributions::mvlgamma(x, n);
		break;
	}
	case dlkj:
	{
		DATA_VECTOR(x);
		DATA_SCALAR(shape);
		DATA_INTEGER(give_log);
		res = distributions::dlkj(x, shape, give_log);
		break;
	}
	case dwishart:
	{
		DATA_VECTOR(x);
		DATA_SCALAR(shape);
		DATA_VECTOR(scale);
		DATA_INTEGER(give_log);
		res = distributions::dwishart(x, shape, scale, give_log);
		break;
	}
	case dinvwishart:
	{
		DATA_VECTOR(x);
		DATA_SCALAR(shape);
		DATA_VECTOR(scale);
		DATA_INTEGER(give_log);
		res = distributions::dinvwishart(x, shape, scale, give_log);
		break;
	}
	}
	REPORT(res);
	return Type(0.0);
}
