import pandas as pd
csv_path = "raw/uber-dataset.csv"
df = pd.read_csv(csv_path)

columns = [
    "Vehicle Type",
    "Booking Status",
    "Reason for cancelling by Customer",
    "Driver Cancellation Reason",
    "Incomplete Rides Reason",
    "Payment Method"
]


unique_values = {}

for col in columns:
    if col in df.columns:
        unique = df[col].dropna().unique() 
        unique_values[col] = list(unique)
        print(f"\n--- {col} ---")
        for val in unique:
            print(val)
    else:
        print(f"\n[AVISO] Coluna '{col}' não encontrada no CSV.")


print("\nArquivo 'unique_values.csv' salvo com sucesso!")
