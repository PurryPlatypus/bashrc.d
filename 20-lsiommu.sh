# list all enumerated PCI(e) devices and their IOMMU group
# I'm not sure who wrote it, originally, not i, nor an LLM ;)
# it's a snippet, i saw Wendell from Level1Techs use
# you can find it in the https://forum.level1techs.com forum
# i've just repackaged it as a bash function
lsiommu () {
shopt -s nullglob
for d in /sys/kernel/iommu_groups/*/devices/*; do 
    n=${d#*/iommu_groups/*}; n=${n%%/*}
    printf 'Group %s ' "$n"
    lspci -nns "${d##*/}"
done;
}
