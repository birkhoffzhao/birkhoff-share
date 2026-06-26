import os
import json
import hashlib
import pandas as pd

os.makedirs("raw_files", exist_ok=True)
os.makedirs("processed_files", exist_ok=True)

city_list = [
    {"city_name": "北京", "code": "101010100"},
    {"city_name": "上海", "code": "101020100"},
    {"city_name": "广州", "code": "101280101"},
    {"city_name": "深圳", "code": "101280601"},
    {"city_name": "杭州", "code": "101210101"},
    {"city_name": "宁波", "code": "101210401"},
    {"city_name": "南京", "code": "101190101"},
    {"city_name": "苏州", "code": "101190401"},
    {"city_name": "成都", "code": "101270101"},
    {"city_name": "重庆", "code": "101040100"},
]

def mask_code(text):
    if not text:
        return ""
    return hashlib.md5(str(text).encode("utf-8")).hexdigest()

if __name__ == "__main__":
    for city in city_list:
        name = city["city_name"]
        code = city["code"]
        print(f"正在处理城市：{name}")

        raw_data = {
            "city_code": code,
            "city_name": name,
            "temp_max": 32,
            "temp_min": 22,
            "weather": "晴",
            "useless_column": "冗余文本"
        }

        raw_path = f"raw_files/raw_{name}.json"
        with open(raw_path, "w", encoding="utf-8") as f:
            json.dump(raw_data, f, ensure_ascii=False, indent=2)

        df = pd.DataFrame([raw_data])
        df = df.drop(columns=["useless_column"])
        df = df[(df["temp_max"] < 60) & (df["temp_min"] > -50)]
        df["city_code"] = df["city_code"].apply(mask_code)

        out_path = f"processed_files/processed_{name}.csv"
        df.to_csv(out_path, index=False, encoding="utf-8-sig")

    print("✅ 全部10个文件采集、清洗、脱敏执行完毕！")