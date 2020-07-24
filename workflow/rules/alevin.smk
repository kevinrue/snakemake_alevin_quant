import glob


rule alevin:
    input:
        unpack(get_gex_fastq),
        index=config['alevin']['index'],
        tgmap=config['alevin']['tgmap']
    output:
        "results/alevin/{sample}/alevin/quants_mat.gz"
    params:
        cells_option=get_cells_option,
        threads=config['alevin']['threads']
    conda:
       "../envs/salmon.yaml"
    threads: config['alevin']['threads']
    resources:
        mem_free_gb=f"{config['alevin']['memory_per_cpu']}"
    log:
        out='results/logs/alevin/{sample}/out',
        err='results/logs/alevin/{sample}/err',
        time='results/logs/time/alevin/{sample}'
    shell:
        """
        {DATETIME} > {log.time} &&
        rm -rf results/alevin/{wildcards.sample} &&
        salmon alevin -l ISR -i {input.index} \
        -1 {input.fastq1} -2 {input.fastq2} \
        -o results/alevin/{wildcards.sample} -p {params.threads} --tgMap {input.tgmap} \
        --chromium --dumpFeatures \
        {params.cells_option} \
        2> {log.err} > {log.out} &&
        {DATETIME} >> {log.time}
        """
