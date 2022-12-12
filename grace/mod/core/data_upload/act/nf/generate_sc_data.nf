process generate_sc_data {

    input:
        val dbpath
        val proj_id
        val file_path
        val ctls

    """
    Rscript ../../../mod/core/data_upload/act/generate_sc_data.R $dbpath $proj_id $file_path "$ctls"
    """

}

workflow {

    generate_sc_data(params.dbpath, params.proj_id, params.file_path, params.ctls)

}
