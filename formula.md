```C
switch (lfp->typefp)
{
    case 1: //creciente y unimodal
        if (varfp > lfp->core1 && varfp < lfp->core2) //core
            grmemb = 1.0;
        else if (varfp > lfp->minfp && varfp < lfp->core1) //decrece
            grmemb = (varfp - lfp->minfp*1.0)/(lfp->core1 - lfp->minfp);
        else if (varfp >= lfp->core2 && varfp < lfp->maxfp) /crece
            grmemb = (lfp->maxfp*1.0 - varfp)/(lfp->maxfp - lfp->core2);
    break;
    case 2: //decreciente
        if (varfp < lfp->core2)
            grmemb = 1.0;
        else if ((varfp >= lfp->core2) && (varfp < lfp->maxfp))
            grmemb = (lfp->maxfp*1.0 - varfp)/(lfp->maxfp - lfp->core2);
    break;
}
```