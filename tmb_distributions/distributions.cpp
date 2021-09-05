#include <TMB.hpp>
#include "distributions.h"

enum test
{
    mvlgamma,
    dlkj,
    dwishart,
    dinvwishart
};

template<class Type>
Type objective_function<Type>::operator() ()
{
    DATA_INTEGER(test_flag);

    switch (test_flag)
    {
    case mvlgamma:
    {
        DATA_VECTOR(x);
	DATA_INTEGER(p);
	int n = x.size();
	vector<Type> res(n);
	for (int i = 0; i < n; ++i)
	{
	    res(i) = distributions::mvlgamma(x(i), p);
	}
	REPORT(res);
        break;
    }
    case dlkj:
    {
        DATA_VECTOR(x);
	DATA_SCALAR(eta);
	DATA_INTEGER(give_log);
	Type res = distributions::dlkj(x, eta, give_log);
	REPORT(res);
        break;
    }
    case dwishart:
    {
        DATA_VECTOR(x);
	DATA_SCALAR(df);
	DATA_VECTOR(scale);
	DATA_INTEGER(give_log);
	Type res = distributions::dwishart(x, df, scale, give_log);
	REPORT(res);
        break;
    }
    case dinvwishart:
    {
        DATA_VECTOR(x);
	DATA_SCALAR(df);
	DATA_VECTOR(scale);
	DATA_INTEGER(give_log);
	Type res = distributions::dinvwishart(x, df, scale, give_log);
	REPORT(res);
        break;
    }
    }
    
    return Type(0.0);
}
