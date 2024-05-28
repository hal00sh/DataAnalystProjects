import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

df = pd.read_csv(r"C:\Users\acer\Documents\TITO\PythonVsc\world_population.csv")
df

pd.set_option('display.float_format', lambda x: '%.2f' % x)
df.info()

df.describe()

df.isnull().sum()

df.nunique()

df.sort_values(by="World Population Percentage", ascending=False).head(10)

df.corr()

sns.heatmap(df.corr(), annot = True)

plt.rcParams['figure.figsize'] = (20,7)

plt.show()

df.groupby('Continent').mean().sort_values(by="2022 Population",ascending=False)

df[df['Continent'].str.contains('Oceania')]

df2 = df.groupby('Continent')[['1970 Population',
       '1980 Population', '1990 Population', '2000 Population',
       '2010 Population', '2015 Population', '2020 Population',
       '2022 Population']].mean().sort_values(by="2022 Population",ascending=False)#df2

df.columns

df3 = df2.transpose()
df3

df3.plot()

df.boxplot(figsize=(20,10))


df.select_dtypes(include='float')