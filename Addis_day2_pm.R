library(readxl) # library containing functions to import from .xls and .xlsx files
read_xlsx("livestock_data.xlsx", sheet = 1) -> cattle_perf
read_xlsx("livestock_data.xlsx", sheet = 2) -> households