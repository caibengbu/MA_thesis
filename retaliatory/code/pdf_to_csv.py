import camelot
import pandas as pd

def pdf_to_csv_single(percent):
    print("start to parse retaliatory_"+str(percent)+".pdf")
    tables = camelot.read_pdf('../input/retaliatory_'+str(percent)+'.pdf', pages='1-end')
    df = pd.DataFrame(columns=["index","hs8","des"])

    for table in tables:
        subdf = table.df.rename(columns={0:"index",1:"hs8",2:"des"})
        df = pd.concat([df,subdf.iloc[1:]]).copy()

    df['hs8_from_hs8'] = df["hs8"].str.extract('(^\d{8})').fillna("")
    df['hs8_from_des'] = df["des"].str.extract('(^\d{8})').fillna("")
    df['final_hs8'] = df['hs8_from_hs8']+df['hs8_from_des']
    df['tariff'] = percent/100
    assert all(df['final_hs8'].apply(len)==8)
    print("parse completed")
    return df[['final_hs8','tariff']]



df_5 = pdf_to_csv_single(5)
df_10 = pdf_to_csv_single(10)
df_20 = pdf_to_csv_single(20)
df_25 = pdf_to_csv_single(25)
pd.concat([df_5,df_10,df_20,df_25]).to_csv("../output/retaliatory_rate_hs8.csv")