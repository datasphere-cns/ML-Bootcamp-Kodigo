# KNN Credit Tier Model (Pipeline)

- Model: scikit-learn Pipeline(StandardScaler + OneHotEncoder + KNeighborsClassifier)
- Trained: 2025-08-16T19:54:41.545670Z
- Target classes: ['Silver', 'Gold', 'Platinum']

## Inference (Python)

```python
import pickle, pandas as pd
with open('knn_credit_tier_pipeline.pkl','rb') as f:
    model = pickle.load(f)
X = pd.DataFrame([{
  'age': 35, 'tenure_years': 5.0, 'dependents': 1, 'num_products': 2, 'income': 1200.0,
  'credit_score': 680, 'is_active': 1, 'has_mortgage': 0, 'balance': 350.0, 'spending_score': 60.0,
  'income_per_dependent': 600.0, 'balance_to_income': 0.25, 'tenure_per_age': 0.14,
  'city': 'San Salvador', 'job_type': 'Professional'
}] )
print(model.predict(X)[0])
print(model.predict_proba(X)[0])
```
