FOLDERS= ../output ../input
all: ../output/shift_share_CD_TS.dta

$(FOLDERS):
	mkdir $@

../input/retaliatory_25.pdf: | ../input
	wget http://www.gov.cn/xinwen/2018-08/03/5311619/files/ffa5fdab36564a0392b03c160894b3f9.pdf -O $@

../input/retaliatory_20.pdf: | ../input
	wget http://www.gov.cn/xinwen/2018-08/03/5311619/files/2614ff88b3eb45e18718f5e76d5513f6.pdf -O $@

../input/retaliatory_10.pdf: | ../input
	wget http://www.gov.cn/xinwen/2018-08/03/5311619/files/6d5fc222395d4dc8bd2c169e73fdaa2c.pdf -O $@

../input/retaliatory_5.pdf: | ../input
	wget http://www.gov.cn/xinwen/2018-08/03/5311619/files/c9b42b65506f48b08b5fda00cefefaea.pdf -O $@

../input/exp-code.txt: | ../input
	wget https://www.census.gov/foreign-trade/schedules/b/2017/exp-code.txt -O $@

../input/emp_by_NAICS_CD.dta: |../input
	ln -s ../../zbp/output/$(@F) $@

../output/retaliatory_rate_hs8.csv: pdf_to_csv.py ../input/retaliatory_25.pdf ../input/retaliatory_20.pdf ../input/retaliatory_10.pdf ../input/retaliatory_5.pdf| ../output
	python $<

../output/TS_by_NAICS.dta: merge_tariff_and_trade.do ../input/imp2017.sas7bdat ../output/retaliatory_rate_hs8.csv ../input/exp-code.txt | ../output
	stata-se -e $<

../output/shift_share_CD_TS.dta: merge_with_emp.do ../output/TS_by_NAICS.dta ../input/emp_by_NAICS_CD.dta | ../output
	stata-se -e $<

