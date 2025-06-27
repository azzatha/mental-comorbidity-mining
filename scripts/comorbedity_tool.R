library(devtools)
#install_bitbucket("ibi_group/disgenet2r")
install_github("aGutierrezSacristan/comoRbidity")

library(comoRbidity)
ex1 <- query( databasePth      = system.file("extdata", package="comoRbidity"),
              codesPth         = system.file("extdata", "indexDiseaseCodes.txt", package="comoRbidity"),
              birthDataSep     = "-",
              admissionDataSep = "-",
              #determinedCodes  = FALSE,
              python           = FALSE)

ex1 <- query( databasePth      = system.file("indexDiseaseCodes.txt", package="comoRbidity"),
                        codesPth         = system.file("extdata", package="comoRbidity"),
                        birthDataSep     = "-",
                        admissionDataSep = "-",
                       
                        python           = FALSE)


load(system.file("extdata", "comorbidity.RData", package="comoRbidity"))
summaryDB( input      = "indexDiseaseCodes.txt", 
           maleCode   = "Male", 
           femaleCode = "Female"
)
