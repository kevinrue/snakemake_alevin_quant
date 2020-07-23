
rule barcode_rank:
    input:
        quants="results/alevin/{sample}/alevin/quants_mat.gz"
    output:
        report("results/plots/{sample}/barcode_rank.svg", caption="../report/barcode_rank.rst", category="Barcode rank plot")
    conda:
        "../envs/r.yaml"
    log: script="results/logs/barcode_rank/{sample}.log"
    script:
        "../scripts/barcode_rank.R"
