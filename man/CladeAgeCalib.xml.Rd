% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CladeAgeCalib.xml.R
\name{CladeAgeCalib.xml}
\alias{CladeAgeCalib.xml}
\title{Include CladeAge blocks into an xml file formatted by BEAUTi
to calibrate the tree in an absolute time frame using BEAST2}
\usage{
CladeAgeCalib.xml(xml.input = NULL, input.tree = NULL, output = NULL,
  CalPointTable = NULL, MinDivRate = NULL, MaxDivRate = NULL,
  MinTurnoverRate = NULL, MaxTurnoverRate = NULL,
  MinSamplingRate = NULL, MaxSamplingRate = NULL, xmltreename = NULL,
  inputTaxono = NULL, Partitions = NULL)
}
\arguments{
\item{xml.input}{an xml input file including topological constraints set-up with
BEAUTi and/or edited using the function MultiTopoCont.EditXML4BEAST2.}

\item{input.tree}{the same rooted tree used by the
\code{\link{MultiTopoConst.EditXML4BEAST2}} function.
If taxa without DNA sequences are present in the analysis then the 'output.new.tree' tree
exported by the \code{\link{MultiTopoConst.EditXML4BEAST2}} function must be provided
instead.}

\item{output}{name of the xml file output ready for BEAST2 analysis
(with the path, if necessary).}

\item{CalPointTable}{a data.frame with 6 columns: the first column reports the name
of the clade used for CladeAge, the second reports the taxonomic reference for
the clade, the third column reports the support for the clade, the fourth
column reports the justification of the first fossil occurrence for the clade,
the fifth and sixth columns report the minimum and maximum age of the fossil,
respectively. If only one age estimate is available for the fossil then the
same age must be reported in both columns. (Only the columns 1, 5 and 6 are
used by the function).}

\item{MinDivRate}{minimum net diversification rate of the clade.}

\item{MaxDivRate}{maximum net diversification rate of the clade.}

\item{MinTurnoverRate}{minimum turnover diversification rate of the clade.}

\item{MaxTurnoverRate}{maximum turnover diversification rate of the clade.}

\item{MinSamplingRate}{minimum sampling rate of fossils for the clade.}

\item{MaxSamplingRate}{maximum sampling rate of fossils for the clade.}

\item{xmltreename}{name of the xml tree in the input xml file.}

\item{inputTaxono}{taxonomic table with species names in the first column
followed by different levels of the classification (e.g.  genus, family,
superfamily, order, class, Division....). If taxa without DNA sequences are
also present in the analysis then the 'output.new.TaxoTable' table exported
by the \code{\link{MultiTopoConst.EditXML4BEAST2}} function must be provided instead.}

\item{Partitions}{If "TRUE" then the alignment included in the xml files contains
more than 1 partition.}
}
\value{
The output .xml file is ready for analysis in BEAST2.
}
\description{
This function edits an .xml file following CladeAge requirements to
time calibrate the tree, based on the age estimate of the first fossil occurrence for
the monophyletic clades retained for the calibration.
The CladeAge approach allows the user to objectively determine the shape of the prior distribution
of the calibration points used to calibrate the tree in an absolute time frame.
}
\details{
CladeAge is based on the oldest fossil occurrence of the
clades used for the calibration, the net diversification rate, diversification
turnover and the fossil sampling rates of the group under investigation.  For a
tutorial about CladeAge analysis see the original paper Matschiner et al. 2017
and the Tutorial "A Rough guide to CladeAge"
(available at: https://www.beast2.org/tutorials/).
}
\examples{
# To run the example, copy the input files
# provided by the package to a temporary directory created in the
# current working directory.
\dontrun{
src.dir = system.file("extdata/TopoConstraints", package = "regPhylo")
dir.create("TempDir.CladeAge")
# Set up the path of the TempDir folder.
dest.dir = paste(getwd(), "/TempDir.CladeAge", sep="")
file.names <- dir(src.dir)
# Copy all the files stored in regPhylo/extdata/TopoConstraints"
# into a temporary folder.
sapply(file.names, function(x) {
file.copy(from = paste(src.dir, x, sep = "/"),
to = paste(dest.dir, x, sep = "/"),
overwrite = FALSE) })

# We include 4 calibration constraints based on 4 clades (Elopomorpha,
# Anguilliformes, Stomiati, Perciformes)
# Import the table (i.e. "CalPointTable") listing the 4 clades constrained
# with the occurrence of the first fossil.
CalibrationTable4clades = read.delim("TempDir.CladeAge/Calib_CA_Fossil_4cl.csv",
sep="\\t", header = TRUE)


#### Example restricted to taxa with at least a DNA sequence in the supermatrix.

# Load the classification table (the same table used for the
# ConstraintTaxo2newick function), one of two ways:
# either through the .Rdata;
data(TopoConstraints) # the second object of the list is the classification table
dim(TopoConstraints[[2]]) # 16 by 23.
# Or the classification table that has been loaded into the temporary directory,
# and can be loaded into the R environment by doing the following:
ClassifDF = read.csv("TempDir.CladeAge/Classif16sp.csv", header = TRUE)
dim(ClassifDF) # 16 by 23

# Load the re-rooted tree (the same tree as for the
# ConstraintTaxo2newick function) in R (note that a rooted tree is available in the
# package and has been loaded in the temporary directory).
require(ape)
TreeRooted = read.nexus("TempDir.CladeAge/RAxML_bipartitions.Concat_7GTR_Allconst_autoMRE_ReRooted")

# All diversification/turnover/sampling rates are from Matschiner et al. 2017.
CladeAgeCalib.xml(xml.input = "TempDir.CladeAge/SimpleXml_Wcont.xml", input.tree = TreeRooted,
output="TempDir.CladeAge/SimpleXml_ReadyForBEAST.xml", CalPointTable = CalibrationTable4clades,
MinDivRate = 0.041, MaxDivRate = 0.081, MinTurnoverRate = 0.0011,
MaxTurnoverRate = 0.37, MinSamplingRate = 0.0066, MaxSamplingRate = 0.01806,
xmltreename = "Subset1", inputTaxono = ClassifDF, Partitions = "TRUE")



#### Example including taxa without DNA sequences in the supermatrix.

# Load the new classification table including the two additional taxa without DNA
# exported by the function MultiTopoConst.EditXML4BEAST2.
NewClassifDF = read.delim("TempDir.CladeAge/Classif18sp_2NoDNA.csv", sep = "\\t", header = TRUE)

# Load the new rooted "RAxML" tree including the two additional taxa and also the
# bootstrap values for each node exported by the function MultiTopoConst.EditXML4BEAST2
require(ape)
NewTree = read.tree("TempDir.CladeAge/BackboneTreeAll_2spNoDNA.txt")

# We then load the calibration table.
CalibrationTable4clades = read.delim("TempDir.CladeAge/Calib_CA_Fossil_4cl.csv",
sep="\\t", header = TRUE)

# Run the function with all other setting and options unchanged.
CladeAgeCalib.xml(xml.input = "TempDir.CladeAge/SimpleXml_2SpNoDNA_Wcont.xml",
input.tree = NewTree,
output = "TempDir.CladeAge/SimpleXml_2SpNoDNA_ReadyForBEAST.xml",
CalPointTable = CalibrationTable4clades,
MinDivRate = 0.041, MaxDivRate = 0.081, MinTurnoverRate = 0.0011,
MaxTurnoverRate = 0.37, MinSamplingRate = 0.0066, MaxSamplingRate = 0.01806,
xmltreename = "Subset1", inputTaxono = NewClassifDF, Partitions = "TRUE")

# To remove the files created while running the example do the following:
unlink("TempDir.CladeAge", recursive = TRUE)

}

}
\references{
Matschiner et al. 2017, DOI:10.1093/sysbio/syw076
}
