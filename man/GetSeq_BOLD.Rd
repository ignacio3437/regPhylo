% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GetSeq_BOLD.R
\name{GetSeq_BOLD}
\alias{GetSeq_BOLD}
\title{Extract DNA sequences and metadata from BOLD (Barcode Of Life Database)}
\usage{
GetSeq_BOLD(splist = NULL, filename = NULL)
}
\arguments{
\item{splist}{a two column table. The first column contains all the binomial species names including
synonyms and the second column contains only the names that will be reported
in the output table as 'species_name'.}

\item{filename}{name of the output table. The format of the output follows the
format provided by the bold R package.}
}
\value{
The function returns three tables: a first table exported within the working directory
with the raw output from bold package plus an additional column with the date of extraction
(this table only reports metadata when the DNA sequence is present), a
list of two tables that are exported into the R environment, including a summary table reporting
the number of occurrences retrieved for each species, and a table reporting all
the data retrieved from bold (including metadata for a recorded specimen eventhough no DNA sequence
is attached, as such the data present in this table and the table exported into the working directory
might differ).
}
\description{
This function extracts sequences and associated information from the Barcode Of
Life Database (BOLD) for all the species in the species list
}
\examples{
# A table with one species
Splist = cbind(TaxID = c("Diastobranchus capensis"), Species.Name = c("Diastobranchus capensis"))
\dontrun{
# Run the function to extract all DNA sequences and associated metadata
BOLD.output = GetSeq_BOLD(splist = Splist, filename = "output.BOLD.txt")

# The output can be loaded doing the following
data(Seq.Diastocapen)
BOLD.output = Seq.Diastocapen$Seq.BOLD

# To remove the file created while running the example do the following:
file.remove("output.BOLD.txt")

}
}
