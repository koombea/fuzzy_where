```C
targs = list_copy(fq->args);
Mu = malloc(list_length(targs)*sizeof (float));
mingrmembQuan = 0.0; 

// Fuzzy Pred
switch (lfp->typefp)
{
    case 1: // unimodal
        if (varfp > lfp->core1 && varfp < lfp->core2) //core
            grmemb = 1.0;
        else if (varfp > lfp->minfp && varfp < lfp->core1) //decrece
            grmemb = (varfp - lfp->minfp*1.0)/(lfp->core1 - lfp->minfp);
        else if (varfp >= lfp->core2 && varfp < lfp->maxfp) //crece
            grmemb = (lfp->maxfp*1.0 - varfp)/(lfp->maxfp - lfp->core2);
    break;
    case 2: // decreciente
        if (varfp < lfp->core2)
            grmemb = 1.0;
        else if ((varfp >= lfp->core2) && (varfp < lfp->maxfp))
            grmemb = (lfp->maxfp*1.0 - varfp)/(lfp->maxfp - lfp->core2);
    break;
    case 3: // creciente
        if (varfp > lfp->core1) 
            grmemb = 1.0;
        else if (varfp > lfp->minfp && varfp <= lfp->core1)
            grmemb = (varfp - lfp>minfp*1.0)/(lfp->core1 - lfp->minfp);
    break;
}

// Fuzzy Quan
switch (fq->typefp)
{
    case 1://Unimodal
    Mu2 = malloc(list_length(targs)*sizeof (float));
        for(i=0; i<list_length(targs); i++){ 
            float j=(float)i+1;
            grmemb = 0.0;
            if(fq->typefq==2){//Relative
                j=i/(float)list_length(targs);
            }
            if (j > (atof(fq->core1)) && j < (atof(fq>core2))) 
                grmemb = 1.0;
            else if (j > (atof(fq->minfp)) && j < (atof(fq->core1))) 
                grmemb = (j - atof(fq->minfp))/(atof(fq->core1) - atof(fq->minfp))
            else if (j >= (atof(fq->core2)) && j < (atof(fq->maxfp)))
                grmemb = (atof(fq->maxfp) - j/(atof(fq->maxfp) - atof(fq->core2)));
            Mu[i]=min(grmemb,Mu[i]);
            Mu2[i]=min(grmemb,1-Mu[i]);
        }
    break;
    case 2: //Decreciente
        for(i=0; i<list_length(targs)-1; i++){
            float j=(float)(i+1);
            grmemb = 0.0;
            if(fq>typefq==2){//Relative
                j=i/(float)list_length(targs);
            }
            if (j < (atof(fq>core2)))
                grmemb = 1.0;
            else if ((j >= (atof(fq->core2))) && (j < (atof(fq->maxfp))))
                grmemb = (atof(fq->maxfp) - j/(atof(fq->maxfp) - atof(fq->core2)));
            Mu[i]=min(grmemb,1-Mu[i+1]);
        }
    break;
    case 3: //Creciente
        for(i=0; i<list_length(targs); i++){
            float j=(float)(i+1);
            grmemb = 0.0;
            if(fq>typefq==2){//Relative
                j=(float)j/(float)list_length(targs);
            }
            if (j >= (atof(fq>core1)))
                grmemb = 1.0;
            else if (j > (atof(fq->minfp)) && j <= (atof(fq->core1))){
                grmemb = (j - atof(fq->minfp))/(atof(fq->core1) - atof(fq->minfp));
            }
            Mu[i]=min(grmemb,Mu[i]);
       }
    break;
}
if(fq->typefp==1){
    mingrmembQuan=min(Mu[mayor(Mu, 0, list_length(targs))],Mu2[mayor(Mu2, 0, list_length(targs)-1)]);
    free(Mu2);
}
else
    mingrmembQuan=Mu[mayor(Mu, 0, list_length(targs))];
free(Mu);
if(node->ps.plan->hasboex) {
    if(node->ps.plan->boextype == AND_EXPR) 
        if (mingrmembQuan < mingrmemb && mingrmembQuan >= 0 && mingrmembQuan <= 1)
            mingrmemb = mingrmembQuan;
    if(node->ps.plan->boextype == OR_EXPR)
        if (mingrmembQuan > mingrmemb && mingrmembQuan >= 0 && mingrmembQuan <= 1)
            mingrmemb = mingrmembQuan;
    if(node->ps.plan->boextype == NOT_EXPR)
        if(mingrmembQuan < 1 && mingrmembQuan > 0) 
            mingrmemb = 1 - mingrmembQuan;
} else
    mingrmemb = mingrmembQuan;
```
