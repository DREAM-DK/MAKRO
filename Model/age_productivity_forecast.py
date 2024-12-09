import dreamtools as dt
import statsmodels.api as sm
import numpy as np

db = dt.Gdx("Gdx/qProdHh_a_forecast.gdx")
BFR_gdx = dt.Gdx("../data/Befolkningsregnskab/BFR.gdx")
sBFR = BFR_gdx.sBFR
BFR = BFR_gdx.BFR

# Vi bruger strukturelle niveauer frem for faktiske, hvor det er muligt
BFR[sBFR.index] = sBFR[sBFR.index]

tEnd = db.tEnd[0]
tDataEnd = db.tDataEnd[0]

# Vi samler først alt data til estimation i dataframe
df = BFR.reset_index().pivot(index=["a_","t"], columns="*", values="BFR").fillna(0).reset_index()
df["BruttoArbsty"] = df[[soc for soc in db.BruttoArbsty if soc in df.columns]].sum(1)
df["tidlig_tilbage"] = df["efterl"] + df["seniorpens"] + df["tidlpens"]

# Fjern aTot'er
df = df[df.a_.isin(db.a)]
# Omdan a-indeks til ints
df["a"] = df["a_"].astype(int)

df = df.merge(db.qProdHh_a.reset_index(), on=["a","t"])

# Omdanner sociogruppe-variable til frekenser
for c in ["pension", "efterl", "BruttoArbsty", "tidlig_tilbage"]:
    df[c] /= df["nPop"] 

# Tidsdummy
df["t_fixed_effect"] = df.t.astype(str)

# Vi vægter efter kohorternes beskæftigelse i timer
df["weights"] = df["hLHh"] * df["nLHh"]


# Vi estimerer kun for 21+ årige i år med alders-fordelt data
sample = df.t.isin(list(range(2016, tDataEnd+1))) & (df.a > 20) & (df.a < 101)

# Vægtet OLS
model = sm.WLS.from_formula(
    weights=df[sample]["weights"],
    formula="qProdHh_a ~ t_fixed_effect + a + BruttoArbsty + pension + tidlig_tilbage",
    data=df[sample]
).fit()

model.summary()


df["Intercept"] = 1
df["fit"] = (model.params * df).sum(1)

# Forecast values as constant after last data year
for year in range(tDataEnd+1, tEnd+1):
    db["qProdHh_a"].loc[:, year] = db["qProdHh_a"].xs(tDataEnd, level="t").values

# Overwrite output database values with fitted values after last data year for 21+ year olds
db["qProdHh_a"].loc[range(21,101), (tDataEnd+1):] = df.set_index(["a", "t"])["fit"].astype(dtype=np.float64)

db.export()

# dt.age_figure_2d(
#     db.qProdHh_a/db.qProdHh_a.loc[60],
#     years=[2016, 2017, 2018, 2019, 2020],
#     start_age=16, end_age=80
# )
# dt.age_figure_2d(db.qProdHh_a/db.qProdHh_a.loc[60], years=[2020, 2060], start_age=16, end_age=100)
