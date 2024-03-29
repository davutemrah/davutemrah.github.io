# An optional custom script to run before Hugo builds your site.
# You can delete it if you do not need it.


# Get list of .ipynb files
file_list <- list.files("content/post", pattern = "\\.ipynb$",
                        full.names = TRUE, recursive = TRUE)

# Loop over each .ipynb file
for (file_path in file_list) {
  # Get the new file name with .Rmd extension
  new_file_name <- gsub("\\.ipynb$", ".Rmd", file_path)
  # Convert .ipynb to .Rmd
  # jupytext::jupytext(file_path, to="Rmd", output= new_file_name)
  rmarkdown::convert_ipynb(file_path, new_file_name)
  print(file_path)
  print(new_file_name)

}


