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
function init_appears() {
    for (i=0; i<3; i++) {
        for(c in ord) appears[i,c] = 0
    }
}
function print_appears() {
    print "- appears[] ----------------------------------------"
    line = ""
    for (c in ord) line = sprintf("%s%c", line, c)
    print line
    for (i=0; i<3; i++) {
        line = ""
        for (c in ord) line = sprintf("%s%i", line, appears[i,c])
        print line
    }
    print "----------------------------------------------------"
}
BEGIN {
    FS=""
    for(n=97;n<123;n++)ord[sprintf("%c",n)]=n
    for(n=65;n<91;n++)ord[sprintf("%c",n)]=n
    prio=0
    init_appears()
}
{
    grp_idx = int(FNR/3)+1
    elf_idx = FNR%3
    if (FNR % 3 == 1) {
        print "===================================================="
        print "Group", grp_idx
    }
    print sprintf("%i:%s", elf_idx, $0)
    for (i = 1; i <= NF; i++) appears[elf_idx,$i]=1
    if (FNR % 3 == 0) {
        print_appears()
        for (c in ord) {
            if (appears[0,c]+appears[1,c]+appears[2,c] == 3) {
                p=calc_prio(c)
                print sprintf("The badge %i (%c) has been found for group %i", p, c, grp_idx)
                prio+=p
            }
        }
        init_appears()
    }
}
END {
    print "========"
    print "Sum of priorities =", prio
}