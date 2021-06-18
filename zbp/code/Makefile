FOLDERS=../output ../input
all: ../output/emp_by_NAICS_CD

$(FOLDERS): 
	mkdir $@

../input/zbp16detail.zip: | ../input
	wget https://www2.census.gov/programs-surveys/cbp/datasets/2016/zbp16detail.zip -O $@

../input/zbp16detail.txt: ../input/zbp16detail.zip | ../input/zbp16detail.zip ../input
	unzip $< -d ../input

../output/emp_by_NAICS_CD.dta: impute_zbp.do ../input/zbp16detail.txt ../input/ZIP_CD_032016.xlsx | ../output
	stata-se -e $<
