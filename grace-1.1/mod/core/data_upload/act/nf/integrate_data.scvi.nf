process integrate_data {

    input:
        val dbpath
        val proj_id
        val data_ids

    """
    Rscript ../../../mod/core/data_upload/act/integrate_data.scvi.R $dbpath $proj_id $data_ids
    """

}

workflow {

    integrate_data(params.dbpath, params.proj_id, params.data_ids)

}
