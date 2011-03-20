from numpy import *
from scipy.special import erfc

'''
Fast (O(n log(n)) implementation of Kendall's Tau
Inspired by the Java implementation part of the it.unimi.dsi.law package (http://law.dsi.unimi.it/)
Based on:
 A Computer Method for Calculating Kendall's Tau with Ungrouped Data
 William R. Knight
 Journal of the American Statistical Association, Vol. 61, No. 314, Part 1 (Jun., 1966), pp. 436-439 
 http://www.jstor.org/pss/2282833
Copyright Enzo Michelangeli, IT Vision Ltd
License: The code in this file is hereby placed in the public domain. Attribution to author would be appreciated.
'''
def kendalltau(x,y):
    initial_sort_with_lexsort = True # if True, ~30% slower (but faster under profiler!) but with better worst case (O(n log(n)) than (quick)sort (O(n^2))
    n = len(x)
    temp = range(n) # support structure used by mergesort
    # this closure recursively sorts sections of perm[] by comparing 
    # elements of y[perm[]] using temp[] as support
    # returns the number of swaps required by an equivalent bubble sort
    def mergesort(offs, length):
        exchcnt = 0
        if length == 1:
            return 0
        if length == 2:
            if y[perm[offs]] <= y[perm[offs+1]]:
                return 0
            t = perm[offs]
            perm[offs] = perm[offs+1]
            perm[offs+1] = t
            return 1
        length0 = length / 2
        length1 = length - length0
        middle = offs + length0
        exchcnt += mergesort(offs, length0)
        exchcnt += mergesort(middle, length1)
        if y[perm[middle - 1]] < y[perm[middle]]:
            return exchcnt
        # merging
        i = j = k = 0
        while j < length0 or k < length1:
            if k >= length1 or (j < length0 and y[perm[offs + j]] <= y[perm[middle + k]]):
                temp[i] = perm[offs + j]
                d = i - j
                j += 1
            else:
                temp[i] = perm[middle + k]
                d = (offs + i) - (middle + k)
                k += 1
            if d > 0:
                exchcnt += d;
            i += 1
        perm[offs:offs+length] = temp[0:length]
        return exchcnt
    
    # initial sort on values of x and, if tied, on values of y
    if initial_sort_with_lexsort:
        # sort implemented as mergesort, worst case: O(n log(n))
        perm = lexsort((y, x))
    else:
        # sort implemented as quicksort, 30% faster but with worst case: O(n^2)
        perm = range(n)
        perm.sort(lambda a,b: cmp(x[a],x[b]) or cmp(y[a],y[b]))
    
    # compute joint ties
    first = 0
    t = 0
    for i in xrange(1,n):
        if x[perm[first]] != x[perm[i]] or y[perm[first]] != y[perm[i]]:
            t += ((i - first) * (i - first - 1)) / 2
            first = i
    t += ((n - first) * (n - first - 1)) / 2
    
    # compute ties in x
    first = 0
    u = 0
    for i in xrange(1,n):
        if x[perm[first]] != x[perm[i]]:
            u += ((i - first) * (i - first - 1)) / 2
            first = i
    u += ((n - first) * (n - first - 1)) / 2
    
    # count exchanges 
    exchanges = mergesort(0, n)
    # compute ties in y after mergesort with counting
    first = 0
    v = 0
    for i in xrange(1,n):
        if y[perm[first]] != y[perm[i]]:
            v += ((i - first) * (i - first - 1)) / 2
            first = i
    v += ((n - first) * (n - first - 1)) / 2
    
    tot = (n * (n - 1)) / 2
    if tot == u and tot == v:
        return 1    # Special case for all ties in both ranks
    
    tau = ((tot-(v+u-t)) - 2.0 * exchanges) / (sqrt(float(( tot - u )) * float( tot - v )))
    
    # what follows reproduces ending of Gary Strangman's original stats.kendalltau() in SciPy
    svar = (4.0*n+10.0) / (9.0*n*(n-1))
    z = tau / sqrt(svar)
    prob = erfc(abs(z)/1.4142136)
    return tau, prob


if __name__ == "__main__":
    import sys
    import time
    import scipy.stats as ss
    #import psyco
    #psyco.full()

    bc = 0.5    # default bivariate correlation between samples
    if len(sys.argv) < 2:
        # test with integers and ties
        x1 = [12,2,1,12,2]
        x2 = [1,4,7,1,0]  
        print "Test with integers and ties: x1 =",x1,", x2 =",x2
        print " fast kendalltau(x1,x2):", kendalltau(x1,x2)
        print " scipy.stats.kendalltau(x1,x2):",ss.kendalltau(x1,x2)
        n = 5000
    else:
        n = int(sys.argv[1])
        # timing test
        if len(sys.argv) > 2:
            bc = float(sys.argv[2])
    
    x = array([random.normal(loc=1, scale=1, size=n),
                random.normal(loc=1, scale=1, size=n)])
    corr = [[1.0, bc],
            [bc, 1.0]]
    x = dot(linalg.cholesky(corr), x)
    x1 = x[0]
    x2 = x[1]
    print "Timing test: x1 and x2 are random.normal(loc=1, scale=1, size="+str(n)+") with correlation",bc

    time_fastkt = time.clock()
    kt = kendalltau(x1,x2)
    time_fastkt = time.clock() - time_fastkt
    print " fast kendalltau():",kt,", time:",around(time_fastkt,decimals=3)
    print " (est. corr =",sin(pi/2.*kt[0])," with st.dev =",around(sqrt((4.*n+10)/(9*n*(n-1))),decimals = 4),")"
    if len(sys.argv) < 2:
        time_slowkt = time.clock()
        sskt = ss.kendalltau(x1,x2)
        time_slowkt = time.clock() - time_slowkt

        print " scipy.stats.kendalltau():",sskt,", time:",around(time_slowkt,decimals=3)
        print
        print "For timing and estimation tests (fast kendalltau only), execute:"
        print sys.argv[0],"number_of_samples [true_correlation]"
    
