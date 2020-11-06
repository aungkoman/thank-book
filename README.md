# Thank Book
ဒါကတော့ Thank Book ကို Flutter နဲ့ ပြန်ရေးထားတာပါ။
Flutter လည်း ဖတ်ရင်း၊ App လည်း လူလူသူသူဖြစ်အောင်လုပ်ရင်းပေါ့ဗျာ။ 
See you on App Store :D
 

#### Day-1 2020-11-05
ဘာတွေ ပြီးလဲ?
- Named Route ရပြီ
- Data Model : ThankNote
- MainListView 
- Fab->onPressed() to Thank New Form
- New Form -> Form Validation and Form Data using state

#### Day-2 2020-11-06
- Data Insert
- Data Select
- Get last inserted id , insert method မှာကို ထောက်ပံ့ပေးထားတယ်။ int တစ်ခု return ပြန်ပေးတယ်။ ကိုယ်က primary key column အတွက်သာ ဘာမှ ထည့်မပေးလိုက်နဲ့။ သူက null လို့ မှတ်ပြီး ROWID လို့ မှတ်ထားတဲ့ ဂဏန်းကို ထည့်ပေးမယ်လို့ sqlite မှာ ရှင်းပြထားတာတွေ့တယ်။
- Data Passing between Route အရင်တစ်ခါလည်း ဖတ်ထားတယ်။ သတိမရဘူး။ Widget  Component Lifecycle မှာ တစ်ခုခု လုပ်လို့ရမယ် ထင်နေတာ။ ပြန်ဖတ်နေရင်းမှ အရင်က ဟာကို တွေ့တယ်။ ```Navigator.pop(context,data)``` ဆိုပြီး pass လုပ်ပေးလိုက်လို့ရတယ်။ ဟိုဘက်ကတော့ Future တစ်ခုကို စောင့်ပေးတဲ့ အနေနဲ့ ```final result = await Navigator.pushNamed(context,route);``` ဆိုပြီး await နဲ့ ရေးထားပေးရမယ်။
- Data Update / Delete : Update ဆိုပေမယ့် insert လုပ်တုန်းက conflict တွေဖြစ်လာရင် replace လုပ်ဆိုပြီး ပြောခဲ့တော့ id တူနေရင် replace လုပ်ပြီး Update ဖြစ်သွားရော :D 
- Route Data Passing ကို လည်း တော်တော်လေး သုံးရတယ်။

