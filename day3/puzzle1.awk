function upperc(c) {
    return ord[c]<95
}
function calc_prio(c) {
    if (upperc(c)) {
        return ord[c]-ord["A"]+27
    } else {
        return ord[c]-ord["a"]+1
    }
}
BEGIN {
    FS=""
    for(n=0;n<256;n++)ord[sprintf("%c",n)]=n
    for(n=ord["a"];n<ord["z"];n++)repeats[sprintf("%c",n)]=0
    for(n=ord["A"];n<ord["Z"];n++)repeats[sprintf("%c",n)]=0
}
{
    for (i=0; i<2; i++) {
        if (i==0) {
            for(n=ord["a"];n<ord["z"];n++)appears[FNR,sprintf("%c",n)]=0
            for(n=ord["A"];n<ord["Z"];n++)appears[FNR,sprintf("%c",n)]=0
        }
        for (j=1; j<=NF/2; j++) {
            c=$(i*(NF/2)+j)
            if (i==0) {
                appears[FNR,c]=1
            } else {
                if (appears[FNR,c]==1) {
                    print "The item", c, "has been found in both compartiments in line", FNR
                    repeats[c]=repeats[c]+1
                    appears[FNR,c]=2
                }
            }
        }
    }
}
END {
    print "========"
    print "Items founds in both compartiments :"
    prio = 0
    for (c in repeats) {
        if (repeats[c]>0) {
            cprio=calc_prio(c)*repeats[c]
            print c, "appears",repeats[c],"times in both compartiments of rucksacks with total priority",cprio
            prio=prio+cprio
        }
    }
    print "Sum of priorities =", prio
}