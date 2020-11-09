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

#### Day-3 2020-11-09
- Date Time Picker ထည့်မယ်၊ field တစ်ခု ထပ်တိုးမယ်
- Notification ပြမယ်။
 
database operation တွေက တစ်ကြောင်းထိုး သွားနေကြတာ။ အဲ့တာကို Future ပြန်ပေးတဲ့အချိန်၊ try{}catch(exp){} နဲ့ ပြန်ပြင်‌ရေးရမယ်။ အခုလိုမျိုး database structure update မဖြစ်သေးချိန်လိုမျိုး error တက်တာကို debug လုပ်မနေပဲ ui မှာတင် သိနိုင်တာမျိုး လုပ်ရမယ်။ ဘာလို့လဲဆို UI Flow လည်း ရပ်သွားတာပဲ မို့လား။ ဘာလို့ရပ်မှန်း အကျိုးသင့် အကြောင်းသင့် ပြသင့်တယ်။

- Database Migration
 
onCreate, onUpgrade, onDowngrade တွေနဲ့ migration script တွေ ရေးထားရမယ်။ drop table တို့ create table တို့ တွေ။

- Setting Page

ဒါလည်း လိုတယ်။ ဒီ app ရဲ့ feature တွေ အကုန်လုံးကို သုံးမယ် မသုံးဘူး၊ ဘယ်လိုပုံစံ သုံးချင်တယ် ဆိုတာမျိုးကို ဒီမှာ ပြင်လို့ရမယ်။ အခု ဉပမာမှာ ဆိုရင် နေ့စဉ် notification တက်ရမလား မတက်ရဘူးလားတွေ မှတ်ထားရမယ်။ ဒီလောက်ကိုတော့ Shared Preference ထဲမှာပဲ အလွယ်မှတ်တာ ကောင်းလိမ့်မယ်။
