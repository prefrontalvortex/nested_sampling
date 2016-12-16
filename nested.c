#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "local_float.h"
#define UNIFORM (rand() / (RAND_MAX)) // Uniform(0,1)
#define logZERO (-DBL_MAX * DBL_EPSILON) // log(0)
#define PLUS(x,y) (x>y ? x+log(1+exp(y-x)) : y+log(1+exp(x-y))) // log(exp(x) + exp(y))

typedef double mytype_t;

typedef struct _Object {
    mytype_t theta;     // YOUR coordinates
    double logL;        // logLikelihood = ln(Prob(data | theta))
    double logWt;       // ln(Weight), summing to SUM(wt)= Evidence Z
} Object;

double logLikelihood(mytype_t theta) {

} // provide this
void Prior( Object *Obj) {
    Obj->theta = UNIFORM;
    Obj->logL = 0.5;
    Obj->logWt = 0.5;
}             //Set object according to prior
void Explore( Object *Obj, double logLstar) {} // Evolve Object within likelihood constraint


int main(int argc, char **argv) {
#define N 100 // Num Objects
#define MAX 9999
    Object Obj[N];
    Object Samples[MAX];
    double logw;            // ln(width in prior mass
    double logLstar;        // ln(Likelihood constraint)
    double H = 0.0;         // Information, init 0
    double logZ = logZERO;  // ln(Evidence Z, init 0);
    double logZnew;         // updated logZ
    int i;
    int copy;       // Duplicated object
    int worst;      // Index of worst object
    int nest;       // Nested sampling iteration count
    double end = 2.0;   // Termination condition nest = end * N * H

    // Set prior objects
    for (i = 0; i < N; i++) {
        Prior(&Obj[i]);
    }
    // Outermost interval of prior mass
    logw = log(1. - exp(-1. / N));

    //// Begin nested sampling loop
    for (nest = 0; nest <= end * N * H; nest++) {
        // [find] Worst object in collection, with Weight = width * likelihood
        worst = 0;
        for (i = 0; i < N; i++) {
            if (Obj[i].logL < Obj[worst].logL) {
                worst = i;
            }
        }
        Obj[worst].logWt = logw + Obj[worst].logL;

        logZnew = PLUS(logZ, Obj[worst].logWt); // Updating Evindence Z and Information H
        H = exp(Obj[worst].logWt - logZnew) * Obj[worst].logL + exp(logZ - logZnew) * (H + logZ) - logZnew;
        logZ = logZnew;
        Samples[nest % MAX] = Obj[worst];   // Posterior samples (optional, care with storage overflow;

        do {                                // Kill worst object in favor of copy of different survivor
            copy = (int)(N * UNIFORM) % N;  // force 0 <= copy < N // wtf.
        } while (copy == worst && N > 1);   // don't kill if N=1 //why?
        logLstar = Obj[worst].logL;         // new likelihood constraint
        Obj[worst] = Obj[copy];             // overwrite worst object

        Explore(&Obj[worst], logLstar);     // Evolve copied object within constraint
        logw -= 1. / N;                     // Shrink Interval

    } //// end nested sampling loop ============================

    //// Begin optional final correction, should be small ========
    logw = -(double) nest / (double) N - log((double) N); // width
    for (i = 0; i < N; i++) {
        Obj[i].logWt = logw + Obj[i].logL; // width * likelihood
        // Update evidence Z and information H
        logZnew = PLUS(logZ, Obj[i].logWt);
        H = exp(Obj[i].logWt - logZnew) * Obj[i].logL
            + exp(logZ - logZnew) * (H + logZ) - logZnew;
        logZ = logZnew;
        // Posterior Samples - overflow risk
//        Samples[nest++] = Obj[i];
    } //// end optional final correction
    //// Exit with evidence Z, information H, and posterior Samples
    printf("# samples = %d\n", nest);
    printf("Evidence: ln(Z) = %g +- %g", logZ, sqrt(H / N));
    printf("Info: H = %g nats | %g bitns", H, H / log(2));

    return EXIT_SUCCESS;
}










