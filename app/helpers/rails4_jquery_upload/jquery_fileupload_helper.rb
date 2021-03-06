module Rails4JqueryUpload
  module JqueryFileuploadHelper

    def jquery_fileupload(engine_mounted_to,
                          target_model,
                          uploader_mounted_to,
                          auto_upload: false,
                          start_all_button: true,
                          cancel_all_button: true,
                          delete_all_button: true,
                          checkboxes: true,
                          filetypes: "undefined",
                          max_files: "undefined",
                          max_file_size_mb: "undefined",
                          preview_max_width: 80,
                          preview_max_height: 80)
      model_name_for_form = target_model.gsub("/", "_").gsub("_", "-")
      html = hidden_inputs(
        target_model, uploader_mounted_to, engine_mounted_to
      ).html_safe

      html << buttonbar(engine_mounted_to,
                        model_name_for_form,
                        auto_upload, filetypes,
                        max_files,
                        max_file_size_mb,
                        preview_max_width,
                        preview_max_height).html_safe
      html << start_all_button_html.html_safe  if start_all_button
      html << cancel_all_button_html.html_safe if cancel_all_button
      html << delete_all_button_html.html_safe if delete_all_button
      html << files_table_html(model_name_for_form).html_safe
      html << download_template_html(checkboxes).html_safe
      html << upload_template_html.html_safe
    end


    def hidden_inputs(target_model, uploader_mounted_to, engine_mounted_to)
      "<input name='hidden_#{target_model}' type='hidden' "\
      "id='submitted_#{target_model}' value></input> " +
      "<input name='uploader_mounted_to_#{uploader_mounted_to}' "\
      "type='hidden' id='uploader_mounted_to_#{uploader_mounted_to}' value></input>" +
      "<input name='engine_mounted_to_#{engine_mounted_to}' "\
      "type='hidden' id='engine_mounted_to_#{engine_mounted_to}' value></input>"
    end


    def buttonbar(engine_mounted_to, target_model, auto_upload, filetypes,
                  max_files, max_file_size_mb, preview_max_width,
                  preview_max_height)
      "<div class='jquery-upload-buttonbar'>
         <span class='btn btn-default btn-file'>
           <span class='glyphicon glyphicon-plus'></span>" +
      t("add_files") +
      add_files_button_html(engine_mounted_to, target_model, auto_upload,
                            filetypes, max_files, max_file_size_mb,
                            preview_max_width, preview_max_height)
    end


    def add_files_button_html(engine_mounted_to, target_model, auto_upload,
                              filetypes, max_files, max_file_size_mb,
                              preview_max_width, preview_max_height)
      "<input data-url='#{engine_mounted_to}/uploads'"\
      "data-auto-upload='#{auto_upload}'"\
      "data-target-model='#{target_model}'"\
      "data-max-files='#{max_files}'"\
      "data-filetypes='#{filetypes}'"\
      "data-max-filesize='#{max_file_size_mb}'"\
      "data-preview-max-width='#{preview_max_width}'"\
      "data-preview-max-height='#{preview_max_height}'"\
      "id='#{target_model}-fileupload' method='patch'"\
      "multiple='multiple' name='files[]' type='file'>"\
      "</span> "
    end

    def start_all_button_html
      "<span class='btn btn-default start' type='submit'>
        <span class='glyphicon glyphicon-upload'></span>" +
        t("start_upload_global") +
      "</span> "
    end

    def cancel_all_button_html
      "<span class='btn btn-default cancel' type='reset'>
        <span class='glyphicon glyphicon-ban-circle'></span>" +
        t("cancel_upload_global") +
      "</span> "
    end

    def delete_all_button_html
      "<span class='btn btn-default delete' type='button'>
        <span class='glyphicon glyphicon-trash'></span>" +
        t("delete_upload_global") +
      "</span>
      <label class='checkbox-inline'>
        <input class='delete-toggle' type='checkbox'>" +
        t("select_all") +
      "</label>"
    end

    def files_table_html(target_model)
      "</div>
      <br>
      <br>
      <table class='table table-striped'>
        <tbody class='#{target_model}-files'></tbody>
      </table>"
    end


    def upload_template_html
      %Q{<script id='template-upload' type='text/x-tmpl'>
      {% for (var i=0, file; file=o.files[i]; i++) { %}
          <tr class='template-upload fade'>
              <td>
                  <span class='preview'></span>
              </td>
              <td>
                  <p class='name'>{%=file.name%}</p>
                  <strong class='error text-danger'></strong>
              </td>
              <td>
                  <p class='size'>Processing...</p>
                  <div class='progress progress-striped active' role='progressbar' aria-valuemin='0' aria-valuemax='100' aria-valuenow='0'><div class='progress-bar progress-bar-success' style='width:0%;'></div></div>
              </td>
              <td>
                  {% if (!i && !o.options.autoUpload) { %}
                      <button class='btn btn-default start' disabled>
                          <span class='glyphicon glyphicon-upload'></span>
                          <span>
                          #{t('start_upload')}
                          </span>
                      </button>
                  {% } %}
                  {% if (!i) { %}
                      <button class='btn btn-default cancel'>
                          <span class='glyphicon glyphicon-ban-circle'></span>
                          <span>
                          #{t('cancel_upload')}
                        </span>
                      </button>
                  {% } %}
              </td>
          </tr>
      {% } %}
      </script>}
    end

    def download_template_html(checkboxes)
      out = %Q[<script id='template-download' type='text/x-tmpl'>
      {% for (var i=0, file; file=o.files[i]; i++) { %}
          <tr class='template-download fade'>
              <td>
                  <span class='preview'>
                      {% if (file.thumbnail_url) { %}
                          <a href='{%=file.url%}' title='{%=file.name%}' download='{%=file.name%}' data-gallery><img src='{%=file.thumbnail_url%}'></a>
                      {% } %}
                  </span>
              </td>
              <td>
                  <p class='name'>
                      {% if (file.url) { %}
                          <a href='{%=file.url%}' title='{%=file.name%}' download='{%=file.name%}' {%=file.thumbnail_url?'data-gallery':''%}>{%=file.name%}</a>
                      {% } else { %}
                          <span>{%=file.name%}</span>
                      {% } %}
                  </p>
                  {% if (file.error) { %}
                      <div><span class='label label-danger'>Error</span> {%=file.error%}</div>
                  {% } %}
              </td>
              <td>
                  <span class='size'>{%=o.formatFileSize(file.size)%}</span>
              </td>
              <td>
                  {% if (file.delete_url) { %}
                      <button class='btn btn-default delete delete-elem' data-method='delete' data-url='{%=file.delete_url%}'{% if (file.deleteWithCredentials) { %} data-xhr-fields='{'withCredentials':true}'{% } %}>
                          <span class='glyphicon glyphicon-trash'></span>
                          <span>
                          #{t('delete_upload')}
                          </span>
                      </button>]
                  out << "\n<input type='checkbox' name='delete' value='1' class='toggle'>\n" if checkboxes
                  out << %Q[{% } else { %}
                      <button class='btn btn-default cancel'>
                          <span class='glyphicon glyphicon-ban-circle'></span>
                          <span>
                          #{t('cancel_upload')}
                          </span>
                      </button>
                  {% } %}
              </td>
          </tr>
      {% } %}
      </script>]
      out
    end

  end
end

