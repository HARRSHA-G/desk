from django.shortcuts import render

# Create your views here.
from django.shortcuts import render,redirect
from django.http import HttpResponse, HttpResponseRedirect,FileResponse
from django.urls import reverse
from . models import inventory_items_stock,Irumudi_bookig_receipt, Maaladharane, Ghee_Coconut, Items_sold_rcpt, Expenses, Daily_Expense, Donations
# Create your views here.
from datetime import datetime
from django.contrib import messages
from reportlab.pdfgen import canvas
import os
global items_list
items_list=[ "Mala 108-130",
    "Mala Gold Cap 108-150",
    "Mala 108-100",
    "Mala 54-80",
    "Mala Gold Cap 54-120",         
    "Towel Mudi-80",
    "Towel Dalapati-75",
    "Panche-160",
    "Panche-180",
    "Panche kavi-250",
    "Bedsheet-180",
    "Bedsheet-200",
    "Irumudi bag-60",
    "Irumudi bag-70",
    "Side bag-130",
    "Side bag-140",
    "Side bag-100",
    "Bell-60",
    "Bell-70",
    "Photo-100",
    "Photo-130",
    "Basma-5",
    "Basma-10",
    "kunkuma-5",
    "Chandana-25",
    "Ghee Bag-10"
    
]
def home(request):
    return render(request,'temple_app/home.html')
def add_items(request):
    
    if request.method=='POST':
        item=inventory_items_stock.objects

        data=request.POST
        item_name=data.get("items_value")
        purchase_price=int(data.get("purchase_price"))
        items_sale_price=int(data.get("items_sale_price"))
        items_in_stock=int(data.get("items_in_stock"))

        filtered_db=item.filter(items=item_name).exists()
        
        if not filtered_db:       
            # no_of_items_sold=data.get("items_sold")

            # item.update_stock_on_sale(4)
            item_creation=item.create(items=item_name,purchase_price=purchase_price,items_sale_price=items_sale_price,items_in_stock=items_in_stock)
            messages.success(request, 'Added successfully')
            return redirect('/update_items')
        else:   
            
            get_item_obj=item.filter(items=item_name)
            my_stocks=get_item_obj.update(purchase_price=purchase_price,items_sale_price=items_sale_price)
            update_row=item.get(items=item_name)
            update_row.update_existing_value(value_update=items_in_stock)

            messages.success(request, 'Updated Successfully ')
            return redirect('/update_items')
       
    return render(request,'temple_app/add_items_list.html',{'list_of_items':items_list})

def irumudi_book(request):
    title="IRUMUDI SCHEDULE"
    cust_data=Irumudi_bookig_receipt.objects
    data=request.POST
    data_recvd={}
    if request.method=="POST":
        my_data={}
       
        Receipt_Number="IR-" + str(cust_data.count()+ 1 + 1000)
        incoming_request=["Receipt_Number","Customer_Name","Contact","Irumudi_Quantity","Schedule_Date","Scheduled_Time","Amount_Paid"]
        pay_mode=data.get("Payment_Mode")
        for i in incoming_request:
            my_data[i]=data.get(i)
            if i=="Receipt_Number":
                my_data[i]=Receipt_Number

      
        # total_amount=int(my_data["Irumudi_Price"])*int(my_data["Irumudi_Quantity"])

        # amt_paid=int(my_data["Amount_Paid"])

      
        # balance=total_amount-amt_paid
        # calculated_data=["Total_Amount","Balance"]
        # str_calculated_data=[total_amount, balance]

        # for k,v in zip(calculated_data,str_calculated_data):
        #     my_data[k]=v

        store_to_db=cust_data.create(**my_data)
       
        get_data_db=cust_data.filter(Receipt_Number=Receipt_Number)
        updating_row=cust_data.get(Receipt_Number=Receipt_Number)
        updating_row.total_amt_update()

        prsent=datetime.now()
        pr_date=prsent.date()

        total_amount_and_amt_paid=get_data_db.values_list("Total_Amount","Amount_Paid")
        total_amount=total_amount_and_amt_paid[0][0]
        amt_paid=total_amount_and_amt_paid[0][1]
        updating_row.balance_update(amt_paid)


        if pay_mode=="cash":
            updating_row.cash_mode(paid_amt=amt_paid)
            if amt_paid==total_amount:
                txt=f'0'
                updating_row.adv_pay(paid_amt=txt)
                updating_row.clear_date(paid_date=pr_date)
            else:
                txt=f'{amt_paid} Cash'
                # print(txt)
                updating_row.adv_pay(paid_amt=txt)
                
        else:
            updating_row.upi_mode(paid_amt=amt_paid)
            if amt_paid==total_amount:
                txt=f'0'
                updating_row.adv_pay(paid_amt=txt)
                updating_row.clear_date(paid_date=pr_date)
            else:
                txt=f'{amt_paid} UPI'
                updating_row.adv_pay(paid_amt=txt)


        rcpt=get_data_db.values("Receipt_Number")[0]["Receipt_Number"]

        date=get_data_db.values("Booking_Date")[0]["Booking_Date"]

        
        cust_info=get_data_db.values("Receipt_Number","Customer_Name","Contact","Irumudi_Price","Irumudi_Quantity","Schedule_Date","Scheduled_Time","Total_Amount","Amount_Paid","Balance")[0]
        
        # Soft-coded file path
        base_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'receipts')
        os.makedirs(os.path.join(base_dir, 'Irmudi'), exist_ok=True)
        file_path = os.path.join(base_dir, 'Irmudi', f'{rcpt}_({date}).pdf')
        
        output_pdf=generate_pdf(file_path,title,rcpt,date,cust_info)

        messages.success(request, 'Booking Successfull')
        
        return  redirect('irumudi_book')
        
        # return redirect('/irumudi_recepit')
    return render(request,'temple_app/book_irumudi.html')
    

def items_list_(request):

    title="ITEMS CONTENTS"


    total_amt_items=int()
    if request.method=="POST":    
        
        data=request.POST
        table=True
        # act=data.get("action")
        col_list=["Item","Qty","Rate","Amount"]
        
        if 'add_button' in request.POST:    
            item_name=data.get("items_value")
            item_qty=data.get("qty")  
            quantity_sold=int(item_qty)   
            
            found_item=inventory_items_stock.objects.filter(items=item_name)
            price_and_qty=found_item.values("items_sale_price","items_in_stock")
            # print("PandQ",price_and_qty )
            found_item_price=price_and_qty[0]["items_sale_price"]
            found_item_stock=price_and_qty[0]["items_in_stock"]
            
            particular_amount=found_item_price*quantity_sold
            get_item=inventory_items_stock.objects.get(items=item_name)

            # print(found_item_price,found_item_stock)

            if  found_item_stock < 1:
                messages.error(request,f'{ item_name} OUT OF STOCK')
                return redirect('/irumudi_items')
            
            
            session_data=f'{item_name}'
            
            request.session[session_data]=[quantity_sold,found_item_price,particular_amount]

            contents=request.session
           
            for k,v in contents.items():
                total_amt_items+=v[2]

            # total_amt_items+=contents[session_data][2]
            print("total_price",total_amt_items)
            return render(request,"temple_app/irumudi_items_list.html",{'data':contents,"col":col_list,"list_of_items":items_list,"Total_amt":total_amt_items})
        elif 'remove_button' in request.POST:
            contents=request.session
            data=request.POST
            itm=data.get("remove_button")
            # print(itm)
            del contents[itm]
            total_amt_items=int()

            for k,v in contents.items():
                total_amt_items+=v[2]

            return render(request,"temple_app/irumudi_items_list.html",{'data':contents,"col":col_list,"list_of_items":items_list,"Total_amt":total_amt_items})   
        
        elif 'submit_button' in request.POST:
            database_obj=Items_sold_rcpt.objects
            Receipt_Number="ML-" + str(database_obj.count()+ 1 + 1000)  
            item_content=request.session
            pay_mode=request.POST.get("Payment_Mode")

            total_amount=int()
            product_name=""
            quantity_sold=int()
            for  key,value in item_content.items():
               price= inventory_items_stock.objects.filter(items=key).values("items_sale_price")[0]["items_sale_price"]
               update_stock=inventory_items_stock.objects.get(items=key)
               update_stock.update_stock_on_sale(quantity_sold=value[0])
               total_amount+=price*value[0]
               product_name+=f"{key}-{value}, "
               quantity_sold

            
            store_to_db=database_obj.create(Receipt_Number=Receipt_Number,Total_Amount=total_amount,Product_name=product_name)
            update_row=database_obj.get(Receipt_Number=Receipt_Number)
            
            

            if pay_mode=="cash":
                update_row.update_cash(paid_amt=total_amount)
            else:
                update_row.update_upi(paid_amt=total_amount)

            fetch_date=database_obj.filter(Receipt_Number=Receipt_Number).values("Date")[0]["Date"]
            # Soft-coded file path
            base_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'receipts')
            os.makedirs(os.path.join(base_dir, 'Materials'), exist_ok=True)
            file_path = os.path.join(base_dir, 'Materials', f'{Receipt_Number}_({fetch_date}).pdf')
            
            output_file=generate_pdf(file_path,title,Receipt_Number,fetch_date,item_content,total_amount,col_list,table)
            request.session.flush()
            messages.success(request, 'Materials Added Successfully ')
            return redirect('/irumudi_items')
    
        elif 'check_button' in request.POST:
            item_name=data.get("items_value")
            stock_item=inventory_items_stock.objects.filter(items=item_name).values("items_in_stock")[0]['items_in_stock']
            messages.info(request, f' Only {stock_item} Left In Stock ')
            return redirect('/irumudi_items')

        elif 'finish' in request.POST:
            request.session.flush()
    return render(request,"temple_app/irumudi_items_list.html", {"list_of_items":items_list})
                                                                                                                                                                                                                                                                                                                             
def maaladharane(request):
    title="MAALADHARANE / ARCHANE"
    database_obj=Maaladharane.objects

    if request.method=="POST":
        data=request.POST
        Customer_Name=data.get("Customer_Name")
        pay_mode=data.get("Payment_Mode")
        Receipt_Number="MD-" + str(database_obj.count()+ 1 + 1000)
    
        store_to_db=database_obj.create(Customer_Name=Customer_Name,Receipt_Number=Receipt_Number)
        
        get_data_db=database_obj.filter(Receipt_Number=Receipt_Number)
        update_row=database_obj.get(Receipt_Number=Receipt_Number)
        if pay_mode=="cash":
            update_row.update_cash()
        else:
            update_row.update_upi()

        cust_info=get_data_db.values("Receipt_Number","Customer_Name","Total_Amount")[0]
        rcpt_no=get_data_db.values("Receipt_Number")[0]["Receipt_Number"]

        date=get_data_db.values("Date")[0]["Date"]

        # Soft-coded file path
        base_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'receipts')
        os.makedirs(os.path.join(base_dir, 'Maladharane'), exist_ok=True)
        file_path = os.path.join(base_dir, 'Maladharane', f'{rcpt_no}_({date}).pdf')

        output_file=generate_pdf(file_path,title,rcpt_no,date,cust_info)

        messages.success(request, 'Submission Successfull')
        return redirect('maaladharane')
    
    return render (request, 'temple_app/maaladharane.html')


def ghee(request):
    title="GHEE / COCONUT"
    database_obj=Ghee_Coconut.objects

    if request.method=="POST":
        data=request.POST

        Customer_Name=data.get("Customer_Name")
        pay_mode=data.get("Payment_Mode")

        Receipt_Number="GC-" + str(database_obj.count()+ 1 + 1000)
    
        store_to_db=database_obj.create(Customer_Name=Customer_Name,Receipt_Number=Receipt_Number)
        
        get_data_db=database_obj.filter(Receipt_Number=Receipt_Number)
        update_row=database_obj.get(Receipt_Number=Receipt_Number)
        if pay_mode=="cash":
            update_row.update_cash()
        else:
            update_row.update_upi()
        cust_info=get_data_db.values("Receipt_Number","Customer_Name","Total_Amount")[0]
        rcpt_no=get_data_db.values("Receipt_Number")[0]["Receipt_Number"]

        date=get_data_db.values("Date")[0]["Date"]

        # Soft-coded file path
        base_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'receipts')
        os.makedirs(os.path.join(base_dir, 'Ghee_coconut'), exist_ok=True)
        file_path = os.path.join(base_dir, 'Ghee_coconut', f'{rcpt_no}_({date}).pdf')
        
        output_file=generate_pdf(file_path,title,rcpt_no,date,cust_info)
        messages.success(request, 'Submission Successfull')
        return  redirect('ghee')
    
    return render (request, 'temple_app/ghee_recp.html')



def irumudi_register(request):
    to_be_paid=int()
    int_amt_paid=int()
    total_amt=int()
    prsent=datetime.now()
    pr_date=prsent.date()
    if 'get_button' in request.POST:
        count=Irumudi_bookig_receipt.objects.filter(Balance__gte=1).count()
        print(count)
        key_col=[]
        data=None
        message=None
        if count>0:
            data=list(Irumudi_bookig_receipt.objects.filter(Balance__gte=1).values())
            
            for k in data[0].keys():
                key_col.append(k)
        else:
            message="No Dues Found !"  
     
        return render (request, 'temple_app/table_record.html',{'data_list':data,'key_set':key_col,'text':message})
    
    elif 'search_due' in request.POST:
        Receipt_Number=request.POST.get("Receipt_Number")
        request.session['Receipt_no']=Receipt_Number
        rx_rc=request.session['Receipt_no']
        
        row_fetch=Irumudi_bookig_receipt.objects.filter(Receipt_Number=Receipt_Number).values("Balance","Amount_Paid","Total_Amount")
    
        to_be_paid =Irumudi_bookig_receipt.objects.filter(Receipt_Number=Receipt_Number).values()[0]["Balance"]
       
        if to_be_paid==0:
            messages.info(request,f"No Dues Found For {rx_rc}")
            request.session.flush()
            return redirect('/irumudi_record')       
        
        return render (request, 'temple_app/records_irumudi.html',{'balance':to_be_paid, 'rx_c':rx_rc})

    elif 'pay_due_clicked' in request.POST:
        title="BALANCE PAID RECEIPT"

        rx_rcpt=request.session["Receipt_no"]
        due=int(request.POST.get("Balance"))
        # print(rx_rcpt,due)
        pay_mode=request.POST.get("Payment_Mode")
        prsent=datetime.now()
        pr_date=prsent.date()

        update_row=Irumudi_bookig_receipt.objects.get(Receipt_Number=rx_rcpt)
        update_amt_paid=update_row.amount_update(ap_value=due)

        update_bal_date=update_row.clear_date(paid_date=pr_date)
        update_bal_paid=update_row.balance_paid(paid_amt=due)
        balance_rcpt_no=f'BRN-{rx_rcpt}'
        update_row.balance_rcpt(no=balance_rcpt_no)

        if pay_mode=="cash":
            update_row.cash_mode(paid_amt=due)
            txt="Cash"
            update_row.bal_pay_mode(mode=txt)
        else:
            txt="UPI"
            update_row.bal_pay_mode(mode=txt)
            update_row.upi_mode(paid_amt=due)
        
        get_all_obj=Irumudi_bookig_receipt.objects.filter(Receipt_Number=rx_rcpt)
        get_info=get_all_obj.values("Balance_Receipt_no","Customer_Name","Contact","Irumudi_Price","Irumudi_Quantity","Schedule_Date","Scheduled_Time","Total_Amount","Amount_Paid","Balance_Amount_Paid","Advance_Paid","Balance")[0]
        get_date=get_all_obj.values("Balance_Clear_Date")[0]["Balance_Clear_Date"]
        get_BNR_no=get_all_obj.values("Balance_Receipt_no")[0]["Balance_Receipt_no"]
        
        # Soft-coded file path
        base_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'receipts')
        os.makedirs(os.path.join(base_dir, 'Balance_receipts'), exist_ok=True)
        file_path = os.path.join(base_dir, 'Balance_receipts', f'{get_BNR_no}_({get_date}).pdf')
        
        closure_pdf=generate_pdf(file_path,title,get_BNR_no,get_date,get_info)
    
        messages.success(request,f" Amount of Rs.{due} Paid ")
        return redirect('/irumudi_record')
    
    request.session.clear()
    return render (request, 'temple_app/records_irumudi.html')
    

def expenses(request):
    pass_data=["Irumudi","Maaladharane","Ghee/Coconut","Materials"]

    if request.method=="POST":
        data=request.POST        
        from_Date=data.get("from_Date")
        to_Date=data.get("to_Date")

        ir_result,ir_cash_value,ir_result2,ir_cash_value2=ir_fun(from_Date,to_Date)

        ir_cash_value = [
            (
                item[0],
                item[5].split()[0],
                item[5].split()[0],
                '0'
            ) if item[5].split()[1] == "Cash" else (
                item[0],
                item[5].split()[0],
                '0',
                item[5].split()[0]
            )
            for item in ir_cash_value
        ]

        # print("fun result",ir_result,ir_result2)
        ml_result=mal_fun(from_Date,to_Date)

        il_result,il_cash_value=il_fun(from_Date,to_Date)

        gc_result=gc_fun(from_Date,to_Date)
        # print(gc_result)

        donation_lst,donation_info=donate_fun(from_Date,to_Date)

        if donation_lst!=[]:
            donate_amt=donation_lst[2]
        else:
            donate_amt=0
       
        zipped_data=[ir_result,ml_result,gc_result,il_result,donation_lst]
        zip2=[ir_result2]
        print(ir_result,ml_result,gc_result,il_result,donation_lst)
        # print(ir_result,ir_result2,ir_cash_value,ir_cash_value2)

       
        grand_total_=0
        cash_grand_total_1=0
        upi_grand_total_1=0

        for i in zipped_data:
            gt,csh,upi=fetch_index(i)
            grand_total_+=gt
            cash_grand_total_1+=csh
            upi_grand_total_1+=upi

        cash_grand_total_2=0
        upi_grand_total_2=0
        grand_total_2=0
        
        for i in zip2:
            gt,csh,upi=fetch_index(i)
            grand_total_2+=gt
            cash_grand_total_2+=csh
            upi_grand_total_2+=upi
        print(grand_total_,grand_total_2)

        grand_total_+=grand_total_2
        cash_grand_total_1+=cash_grand_total_2
        upi_grand_total_1+= upi_grand_total_2
        
        
        overall_grand_total=grand_total_
        net_result,exp_values,exp_grand_total=exp_fun(from_Date,to_Date,overall_grand_total)
        net_result=net_result-upi_grand_total_1
        col1=["Receipt Range","Sold","Total Cost","Cash","UPI"]
        col2=["Receipt Range","Total Donation"]


        return render(request,'temple_app/report_table.html',{"ir_data":ir_result,'ml_data': ml_result,"gl_data":gc_result, "id_data":il_result,"col1":col1,"from_date":from_Date,"to_date":to_Date,"items_sold":il_cash_value,"irumudi_sold":ir_cash_value,"gt":grand_total_,"exp_values":exp_values,"grand_total":exp_grand_total,"net_balance":net_result,"col2":col2,"donation_amt":donation_lst,"donation_values":donation_info,"ir_data2":ir_result2,"irumudi_sold2":ir_cash_value2,"cash_gt_1":cash_grand_total_1,"upi_gt_1":upi_grand_total_1,"cash_gt_2":cash_grand_total_2,"upi_gt_2":upi_grand_total_2,"gt_2":grand_total_2,"ogt":overall_grand_total})
    
    return render(request,'temple_app/cash_report.html',{'my_rcpts':pass_data})
    

def expense(request):
    if request.method=="POST":
        data=request.POST
        Description=data.get("Description")
        Amount=int(data.get("Amount_Spent"))
        store_o_db=Expenses.objects.create(Description=Description,Amount=Amount)

    return render(request,'temple_app/exp_entry.html')

def scheduled_irumudi(request):
    if request.method=='POST':
        data=request.POST
        from_date=data.get("from_Date")
        to_date=data.get("to_Date")
        key_col=[]
        fetch_data=None
        message=None
    
        fetch_data=Irumudi_bookig_receipt.objects.filter(Schedule_Date__range=(from_date,to_date)).values()
        print("TRY WAS CALLED",fetch_data)
        if not fetch_data.exists():
            print("Not exist")
            message=f"No Schedules from {from_date} to {to_date}"
            return render (request, 'temple_app/table_record.html',{'data_list':fetch_data,'key_set':key_col,'text':message})
        for k in fetch_data[0].keys():
            key_col.append(k)
        print(key_col)
        return render (request, 'temple_app/table_record.html',{'data_list':fetch_data,'key_set':key_col,'text':message,'from_date':from_date,'to_date':to_date})    

    return render(request,'temple_app/scheduled_list_irumudi.html')

def donate(request):
    rcpt_title="DONATION"
    if request.method=="POST":
        data=request.POST
        Customer_Name=data.get("Customer_Name")
        Contact=data.get("Contact")
        Amount_Paid=data.get("Amount_Paid")
        Payment_Mode=data.get("Payment_Mode")

        database_obj=Donations.objects
        Receipt_Number="DN-" + str(database_obj.count()+ 1 + 1000)

        store_to_db=database_obj.create(Receipt_Number=Receipt_Number,Customer_Name=Customer_Name,Contact=Contact,Amount_Paid=Amount_Paid)
        get_obj=database_obj.get(Receipt_Number=Receipt_Number)
        if Payment_Mode=="cash":
            get_obj.update_cash(paid_amt=Amount_Paid)
        else:
            get_obj.update_upi(paid_amt=Amount_Paid)
        donation_db=database_obj.filter(Receipt_Number=Receipt_Number)


        donation_info=donation_db.values("Receipt_Number","Customer_Name","Contact","Amount_Paid")[0]
        rcpt_no=donation_db.values("Receipt_Number")[0]["Receipt_Number"]

        pr_date=donation_db.values("Date")[0]["Date"]
        
        # Soft-coded file path
        base_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'receipts')
        os.makedirs(os.path.join(base_dir, 'Donations'), exist_ok=True)
        file_path = os.path.join(base_dir, 'Donations', f'{rcpt_no}_({pr_date}).pdf')
        
        out=generate_pdf(file_path,rcpt_title,rcpt_no,pr_date,donation_info,None,None,False,True)
        print(donation_db)
        messages.success(request, 'Donation Successfull')
        return redirect('donate')
       
    return render(request,'temple_app/donation.html')


def generate_pdf(file_path,rcpt_title,rcpt_no,current_date,query_data,total_amt=None,col_name_list=None,table=False,dn=False):
   
    sl_no=1
    header=["                   || Om Sri Swami Sharanam Ayyappa ||        "                         
            ,"  Sri Kaliyuga Varada Ayyappaswamy Temple, Ranganathapura,       ",
            "         Prashanthanagar, 6th Main Road, Bangalore - 79.       "]
    

    y=660
    y2=800
    x=50
    last_line_2=f'Cashier Signature:'
    p = canvas.Canvas(file_path)
    p.setFont("Helvetica", 10)
    if dn:
        text=f'THANKS FOR YOUR CONTRIBUTION'
        p.drawString(10,600,text)

    # if total_amt:
    #     text=f'Total Amount: Rs.{total_amt}'
    #     p.drawString(10,680,text)

    p.drawString(130,710,rcpt_title)

    present_date=f'Date : {current_date}'

    p.drawString(10,710,present_date)

    for i in header:
        op=f'{i}'
        p.drawString(40,y2, op)
        y2-=25

    if table:
        # print("length of list",len(query_data.items()))
        for col_name in col_name_list:
            res=f'{col_name}'
            p.drawString(x,680, res)
            if col_name=="Item": 
                x+=145
            else:
                x+=35
        counter=0
        for key,value in query_data.items():
            res=f'{sl_no}. {key}'
            res2= f'{value[0]}         {value[1]}        {value[2]}'
            sl_no+=1
            p.drawString(10,y, res)  
            p.drawString(200,y,res2)
            y-=20
            counter+=1

            if counter==len(query_data.items()):
                last_line_1=f'Total Amount: Rs. {total_amt}'
                p.drawString(188,y,last_line_1)

                last_y=y-20
                p.drawString(10,last_y,last_line_2)
                
    else: 
        count=0       
        for key,value in query_data.items():
            if key=="Total_Amount" :
                res=f' {key} : Rs. {value}. '
            elif key== "Amount_Paid":
                res=f' {key} : Rs. {value}. '

            elif key=="Balance":      
                res=f' {key} : Rs. {value}. '

            elif key=="Balance_Amount_Paid":
                res=f' {key} : Rs. {value}. '
            elif key=="Advance_Paid":
                res=f' {key} : Rs. {value}. '
            else:
                res=f' {sl_no}. {key} : {value}'
                sl_no+=1

            p.drawString(10,y, res)  
            y-=20
            count+=1
            if count==len(query_data.items()):
                p.drawString(10,y-10, last_line_2)  
    p.showPage()
    p.save()
    


def ir_fun(from_date,to_date):
    irumudi_list=[]
    irumudi_cash_values=[]

    irumudi_list2=[]
    irumudi_cash_values2=[]
    date_object = datetime.strptime(from_date, '%Y-%m-%d').date()
    date_object2 = datetime.strptime(to_date, '%Y-%m-%d').date()
    
    irumudi_cash=Irumudi_bookig_receipt.objects.all().filter(Booking_Date__range=(from_date,to_date))
    irumudi_2_cash=Irumudi_bookig_receipt.objects.all().filter(Balance_Clear_Date__range=(from_date,to_date))
    try:
       
        # print("I AWS CALLED IR",irumudi_2_cash,irumudi_cash)

        if irumudi_cash.exists():
            irumudi_sale_count=irumudi_cash.count()
            irumudi_cash_values=irumudi_cash.values_list("Receipt_Number","Balance_Clear_Date","Amount_Paid","Cash","UPI","Advance_Paid")
            print("Cash Values:",irumudi_cash_values)

            end_index=irumudi_sale_count-1
            start_rcpt=irumudi_cash_values[0][0]
            end_rcpt=irumudi_cash_values[end_index][0]

            total_cost_in_set_period=0
            cash_amt=0
            upi_amt=0

            for key,bcd,val,csh,upi,advp in irumudi_cash_values:
                if key!= None:
                    val_spli = int(advp.split()[0])
                    mode = advp.split()[1]
                    total_cost_in_set_period += val_spli
                    # irumudi_cash_values=irumudi_cash.values_list("Receipt_Number","Balance_Clear_Date","Advance_Paid","Cash","UPI","Amount_Paid")
                    if mode == 'Cash':
                        cash_amt += val_spli
                    else:
                        upi_amt += val_spli
                    continue
                    # total_cost_in_set_period+=val
                    # cash_amt+=csh
                    # upi_amt+=upi
                    # irumudi_cash_values=irumudi_cash.values_list("Receipt_Number","Balance_Clear_Date","Amount_Paid","Cash","UPI","Advance_Paid")

                # elif bcd>date_object2:
                #     val_spli=int(advp.split()[0])
                #     total_cost_in_set_period+=val_spli
                #     # irumudi_cash_values=irumudi_cash.values_list("Receipt_Number","Balance_Clear_Date","Advance_Paid","Cash","UPI","Amount_Paid")
                #     continue
                #
                # elif bcd==None:
                #     val_spli=int(advp.split()[0])
                #     mode=advp.split()[1]
                #     total_cost_in_set_period+=val_spli
                #     # irumudi_cash_values=irumudi_cash.values_list("Receipt_Number","Balance_Clear_Date","Advance_Paid","Cash","UPI","Amount_Paid")
                #     if mode=='Cash':
                #         cash_amt+=val_spli
                #     else:
                #         upi_amt+=val_spli
                #     continue
               
            irumudi_list=[(start_rcpt,end_rcpt),irumudi_sale_count,total_cost_in_set_period,cash_amt,upi_amt]
            # print(start_rcpt,end_rcpt,irumudi_sale_count,total_cost_in_set_period)
        
        if irumudi_2_cash.exists():
            print("2 was called ")
            irumudi_sale_count2=irumudi_2_cash.count()
            irumudi_cash_values2=irumudi_2_cash.values_list("Balance_Receipt_no","Balance_Amount_Paid","Balance_Amount_Payment_Mode","Booking_Date","Balance_Clear_Date")

            # print(irumudi_2_cash)

            end_index2=irumudi_sale_count2-1
            start_rcpt2=irumudi_cash_values2[0][0]

            end_rcpt2=irumudi_cash_values2[end_index2][0]

            total_cost_in_set_period2=0
            cash_amt2=0
            upi_amt2=0
            
            for key,val,pay_mode,bkd,bcd in irumudi_cash_values2:
               
                # if (bkd==bcd)  :
                #     total_cost_in_set_period2+=0
                #     continue
                # elif (bcd>date_object) :
                #     total_cost_in_set_period2+=0
                #     continue

                total_cost_in_set_period2+=val
                if pay_mode=="Cash":
                    cash_amt2+=val
                elif pay_mode=="UPI":
                    upi_amt2+=val
                # print(key,val)

            irumudi_list2=[(start_rcpt2,end_rcpt2),irumudi_sale_count2,total_cost_in_set_period2,cash_amt2,upi_amt2]
            # print(irumudi_list2)

        print("irumudi_list",irumudi_list,"\n Irumudi cash",irumudi_cash_values,"\n Irumudi 2",irumudi_list2,"\n Irumudi cash 2 ",irumudi_cash_values2)
        return irumudi_list,irumudi_cash_values,irumudi_list2,irumudi_cash_values2
    except:
        return irumudi_list,irumudi_cash_values,irumudi_list2,irumudi_cash_values2
       
            

def mal_fun(from_date,to_date):
    ## MAALADHARANE
    try:
        maaladharane_cash=Maaladharane.objects.all().filter(Date__range=(from_date,to_date))
        if not maaladharane_cash.exists():
            maaladharane_list=[]
            return maaladharane_list
    except:
        maaladharane_cash=Maaladharane.objects.all().filter(Date=from_date)
        if not maaladharane_cash.exists():
            # print("ML INVALID")
            maaladharane_list=[]
            return maaladharane_list
        
    maaladharane_cash_count=maaladharane_cash.count()

    maaladharane_cash_values=maaladharane_cash.values_list("Receipt_Number","Date","Total_Amount","Cash","UPI")

    maaladharane_end_index=maaladharane_cash_count-1

    maaladharane_start_rcpt=maaladharane_cash_values[0][0]
    maaladharane_end_rcpt=maaladharane_cash_values[maaladharane_end_index][0]

    total_cost_maaladharne=0
    cash_amt=0
    upi_amt=0

    for k,v,amt,csh,upi in maaladharane_cash_values:
        total_cost_maaladharne+=amt
        cash_amt+=csh
        upi_amt+=upi

    # print(maaladharane_start_rcpt,maaladharane_end_rcpt,maaladharane_cash_count,total_cost_maaladharne)
    maaladharane_list=[(maaladharane_start_rcpt,maaladharane_end_rcpt),maaladharane_cash_count,total_cost_maaladharne,cash_amt,upi_amt]    
    return maaladharane_list

def il_fun(from_date,to_date):
    
    ## Items_sold_rcpt
    try:
        items_sold_rcpt_cash=Items_sold_rcpt.objects.all().filter(Date__range=(from_date,to_date))
        if not items_sold_rcpt_cash.exists():
            items_data_list=[]
            return items_data_list,None
    except: 
        items_sold_rcpt_cash=Items_sold_rcpt.objects.all().filter(Date=from_date)
        if not items_sold_rcpt_cash.exists():
            items_data_list=[]
            return items_data_list,None

    items_sold_rcpt_cash_count=items_sold_rcpt_cash.count()

    items_sold_rcpt_cash_values=items_sold_rcpt_cash.values_list("Receipt_Number","Total_Amount","Cash","UPI")

    items_sold_end_index=items_sold_rcpt_cash_count-1
    # print(items_sold_rcpt_cash_values)

    items_startindex=items_sold_rcpt_cash_values[0][0]

    items_endindex=items_sold_rcpt_cash_values[items_sold_end_index][0]

    total_cost_items=0
    cash_amt=0
    upi_amt=0

    for k,v,csh,upi in items_sold_rcpt_cash_values:
        total_cost_items+=v
        cash_amt+=csh
        upi_amt+=upi


    # print(items_startindex,items_endindex,items_sold_rcpt_cash_count,total_cost_items)
    
    items_data_list=[(items_startindex,items_endindex),items_sold_rcpt_cash_count,total_cost_items,cash_amt,upi_amt]
    return items_data_list,items_sold_rcpt_cash_values

def gc_fun(from_date,to_date):
    
##GheeCoconut
    try:
        gc_cash=Ghee_Coconut.objects.all().filter(Date__range=(from_date,to_date))
        if not gc_cash.exists():
            gc_list=[]
            return gc_list

    except:
        gc_cash=Ghee_Coconut.objects.all().filter(Date=from_date)
        if not gc_cash.exists():
            gc_list=[]
            return gc_list

    gc_cash_count=gc_cash.count()

    gc_cash_values=gc_cash.values_list("Receipt_Number","Date","Total_Amount","Cash","UPI")

    gc_end_index=gc_cash_count-1

    gc_start_rcpt=gc_cash_values[0][0]
    gc_end_rcpt=gc_cash_values[gc_end_index][0]

    total_cost_gc=0
    cash_amt=0
    upi_amt=0

    for k,v,amt,csh,upi in gc_cash_values:
        total_cost_gc+=amt
        cash_amt+=csh
        upi_amt+=upi
    # print(gc_start_rcpt,gc_end_rcpt,gc_cash_count,total_cost_gc)
    gc_list=[(gc_start_rcpt,gc_end_rcpt),gc_cash_count,total_cost_gc,cash_amt,upi_amt]    
    return gc_list

def exp_fun(from_date,to_date,grand_total):
    try:
        exp_data=Expenses.objects.all().filter(Date__range=(from_date,to_date))
        if not exp_data.exists():
            return grand_total,None,None
    except:
        exp_data=Expenses.objects.all().filter(Date=from_date)
        if not exp_data.exists():
            return grand_total,None,None

    exp_values=exp_data.values_list("Description","Amount")
    exp_grand_total=0

    for k,v in exp_values:
        exp_grand_total+=v
        # print(k,v)

    net_balance=grand_total-exp_grand_total
    return net_balance,exp_values,exp_grand_total

def daily_fun(net_balance):
    income_col=None
    date_col=None
    last_row=Daily_Expense.objects.last()
    income_col=last_row.Income
    date_col=last_row.Date
    
    prsent=datetime.now()
    pr_date=prsent.date()
  
    # print("############my_income", income_col,date_col,prsent,pr_date)

    if date_col==pr_date:
        print("Yes Equal")
        db=Daily_Expense.objects.filter(Date=date_col)
        db_inst=Daily_Expense.objects.get(Date=date_col)
        op=db.values_list("Date","Income")[0]
        db_date=op[0]
        db_income=op[1]

        if db_income!=net_balance:
            print("unequal")
            update_row= db_inst.daily_update(today_balance=net_balance)
            up_value=db.values_list("Income")[0][0]
            print(db_date,db_income,up_value)
            return up_value
        print(db_date,db_income)
        return db_income
    else:
        prev_day=income_col+net_balance
        Daily_Expense.objects.create(Income=prev_day)
        fresh_row=Daily_Expense.objects.last()
        curr_net_balnce=fresh_row.Income
        print(curr_net_balnce)
        return curr_net_balnce
    
def donate_fun(from_date,to_date):
    fetch_data=Donations.objects.filter(Date__range=(from_date,to_date))
    if not fetch_data.exists():
        return [],[]
    print("Donation Available")
    db_values=fetch_data.values_list("Receipt_Number","Amount_Paid","Cash","UPI")
    db_count=fetch_data.count()
    db_end_index=db_count-1
    total_donation=0
    start_index=db_values[0][0]
    end_index=db_values[db_end_index][0]
    cash_total=0
    upi_total=0
    for rc,amt,csh,upi in db_values:
        total_donation+=amt
        cash_total+=csh
        upi_total+=upi

    print(total_donation)
    donation_list=[(start_index,end_index),db_count,total_donation,cash_total,upi_total]
    return donation_list,db_values
   


def fetch_index(list_of_lists):
    
    if list_of_lists==[]:
        return 0,0,0
    else:
        return list_of_lists[2],list_of_lists[3],list_of_lists[4]

def Calculator(request):
    return render (request, 'temple_app/Calculator.html')

def irumudi_by_receipt_fun(from_receipt,to_receipt):
    fetch_data=Irumudi_bookig_receipt.objects.filter(filter__range=(from_receipt,to_receipt))
    if not fetch_data.exists():
        return [],[]
    print("Irumudi Available")
    db_values=fetch_data.values_list("Receipt_Number","Amount_Paid","Cash","UPI")
    db_count=fetch_data.count()
    db_end_index=db_count-1
    total_irumudi=0
    start_index=db_values[0][0]
    end_index=db_values[db_end_index][0]
    cash_total=0
    upi_total=0
    for rc,amt,csh,upi in db_values:
        total_irumudi+=amt
        cash_total+=csh
        upi_total+=upi

    print(total_irumudi)
    irumudi_list=[(start_index,end_index),db_count,total_irumudi,cash_total,upi_total]
    return irumudi_list,db_values

def check_irumudi_receipts(request):
    if request.method == "GET":
        start_receipt = request.GET.get("start_receipt")
        end_receipt = request.GET.get("end_receipt")

        if not start_receipt or not end_receipt:
            return JsonResponse({"error": "Missing receipt numbers"}, status=400)

        # Check if any Irumudi receipts exist within the range
        receipts = Irumudi_bookig_receipt.objects.filter(
            Start_Receipt_Number__lte=end_receipt,
            End_Receipt_Number__gte=start_receipt
        )

        if receipts.exists():
            data = [
                {
                    "start": receipt.Start_Receipt_Number,
                    "end": receipt.End_Receipt_Number,
                    "total_amount": receipt.Total_Amount,
                    "cash": receipt.Cash,
                }
                for receipt in receipts
            ]
            return JsonResponse({"success": True, "receipts": data})
        else:
            return JsonResponse({"success": False, "message": "No Irumudi receipts found."})
        

##  Sushmitha 2/3/25
from .models import Irumudi_bookig_receipt

def get_irumudi_details(request):
    start_receipt_number = request.GET.get('start_receipt_number', None)
    end_receipt_number = request.GET.get('end_receipt_number', None)
    irumudi_details = []

    if start_receipt_number and end_receipt_number:
        try:
            irumudi_details = Irumudi_bookig_receipt.objects.filter(
                Receipt_Number__gte=start_receipt_number,  # Greater than or equal to start receipt number
                Receipt_Number__lte=end_receipt_number   # Less than or equal to end receipt number
            )

        except Exception as e:
            irumudi_details = []
            error_message = str(e)

    return render(request, 'temple_app/get_irumudi_details.html', {'irumudi_details': irumudi_details})

## Pitchu 13/3/25

from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .models import Report, Expense
import json

def report_generator(request):
    return render(request, 'temple_app/report_generator.html')

def report_viewer(request):
    return render(request, 'temple_app/report_viewer.html')

# harsha_15-5-2025 Requirement

from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .models import Report, Expense, ghee_coconut_new, Maladharane_new, Irumudi_new, Donation_new, Materials_new, UPI_new
import json
from datetime import datetime
import logging

# Set up logging
logger = logging.getLogger(__name__)

@csrf_exempt
def save_report(request):
    if request.method == 'POST':
        try:
            # Log raw request body
            logger.info(f"Raw request body: {request.body}")
            
            data = json.loads(request.body)
            logger.info(f"Parsed data: {data}")
            
            # Validate required fields
            required_fields = ['date', 'grand_total', 'upi_total', 'expense_total']
            for field in required_fields:
                if field not in data:
                    raise ValueError(f"Missing required field: {field}")
            
            date = datetime.strptime(data['date'], '%Y-%m-%d').date()
            grand_total = float(data['grand_total'])
            upi_total = float(data['upi_total'])
            expense_total = float(data['expense_total'])
            opening_balance = float(data.get('opening_balance', 0))
            cash_total = grand_total - (upi_total + expense_total)

            logger.info(f"Creating main report with date: {date}, grand_total: {grand_total}")
            
            # Create main report
            report = Report.objects.create(
                date=date,
                grand_total=grand_total,
                upi_total=upi_total,
                expense_total=expense_total
            )
            logger.info(f"Main report created with ID: {report.id}")

            # Save Opening Balance
            if data.get('opening_balance'):
                try:
                    from .models import OB_new
                    ob_obj = OB_new.objects.create(
                        date=date,
                        amount=float(data['opening_balance'])
                    )
                    logger.info(f"Created Opening Balance record: {ob_obj.id}")
                except Exception as e:
                    logger.error(f"Error saving Opening Balance data: {str(e)}")
                    logger.error(f"Opening Balance data that caused error: {data['opening_balance']}")

            # Save Ghee/Coconut data
            for gc in data.get('gc', []):
                try:
                        gc_obj = ghee_coconut_new.objects.create(
                            date=date,
                        receipt_range_start=gc['receipt_range_start'],
                        receipt_range_end=gc['receipt_range_end'],
                        receipts_count=gc['receipts_count'],
                        total_cost=gc['total_cost']
                        )
                        logger.info(f"Created GC record: {gc_obj.id}")
                except Exception as e:
                    logger.error(f"Error saving GC data: {str(e)}")
                    logger.error(f"GC data that caused error: {gc}")

            # Save Maladharane data
            for ml in data.get('ml', []):
                try:
                        ml_obj = Maladharane_new.objects.create(
                            date=date,
                        receipt_range_start=ml['receipt_range_start'],
                        receipt_range_end=ml['receipt_range_end'],
                        receipts_count=ml['receipts_count'],
                        total_cost=ml['total_cost']
                        )
                        logger.info(f"Created ML record: {ml_obj.id}")
                except Exception as e:
                    logger.error(f"Error saving ML data: {str(e)}")
                    logger.error(f"ML data that caused error: {ml}")

            # Save Irumudi data
            for ir in data.get('irumudi', []):
                try:
                        ir_obj = Irumudi_new.objects.create(
                            date=date,
                        receipt_number=ir['receipt_number'],
                        amount=ir['amount']
                        )
                        logger.info(f"Created IR record: {ir_obj.id}")
                except Exception as e:
                    logger.error(f"Error saving IR data: {str(e)}")
                    logger.error(f"IR data that caused error: {ir}")

            # Save Donation data
            for dn in data.get('donation', []):
                try:
                        dn_obj = Donation_new.objects.create(
                            date=date,
                        receipt_number=dn['receipt_number'],
                        amount=dn['amount']
                        )
                        logger.info(f"Created DN record: {dn_obj.id}")
                except Exception as e:
                    logger.error(f"Error saving DN data: {str(e)}")
                    logger.error(f"DN data that caused error: {dn}")

            # Save Material data
            for mt in data.get('material', []):
                try:
                        mt_obj = Materials_new.objects.create(
                            date=date,
                        receipt_number=mt['receipt_number'],
                        amount=mt['amount']
                        )
                        logger.info(f"Created MT record: {mt_obj.id}")
                except Exception as e:
                    logger.error(f"Error saving MT data: {str(e)}")
                    logger.error(f"MT data that caused error: {mt}")

            # Save UPI data
            for upi in data.get('upi', []):
                try:
                        upi_obj = UPI_new.objects.create(
                            date=date,
                        amount=upi['amount']
                        )
                        logger.info(f"Created UPI record: {upi_obj.id}")
                except Exception as e:
                    logger.error(f"Error saving UPI data: {str(e)}")
                    logger.error(f"UPI data that caused error: {upi}")

            # Save Expense data
            for exp in data.get('expense', []):
                try:
                        exp_obj = Expense.objects.create(
                            date=date,
                        expense_name=exp['expense_name'],
                        amount=exp['amount']
                        )
                        logger.info(f"Created Expense record: {exp_obj.id}")
                except Exception as e:
                    logger.error(f"Error saving Expense data: {str(e)}")
                    logger.error(f"Expense data that caused error: {exp}")

            # Return success response with calculated totals
            return JsonResponse({
                'status': 'success',
                'message': 'Report saved successfully',
                'data': {
                    'opening_balance': opening_balance,
                    'cash_total': cash_total,
                    'upi_total': upi_total,
                    'expense_total': expense_total,
                    'grand_total': grand_total
                }
            })
        except Exception as e:
            logger.error(f"Error in save_report: {str(e)}")
            return JsonResponse({'status': 'error', 'message': str(e)})
    return JsonResponse({'status': 'error', 'message': 'Invalid request method'}) 


def fetch_report_by_date(request):
    try:
        date_str = request.GET.get('date')
        date2_str = request.GET.get('date2')  # Get the end date
        
        if not date_str:
            return JsonResponse({'status': 'error', 'message': 'Date is required'})

        start_date = datetime.strptime(date_str, '%Y-%m-%d').date()
        end_date = datetime.strptime(date2_str, '%Y-%m-%d').date() if date2_str else start_date
        
        # Use raw SQL queries to ensure we get fresh data
        from django.db import connection
        
        # Fetch data from all _new tables for the date range using raw SQL
        with connection.cursor() as cursor:
            # Opening Balance
            cursor.execute("SELECT * FROM temple_ob_new WHERE date BETWEEN %s AND %s", [start_date, end_date])
            ob_data = [dict(zip([col[0] for col in cursor.description], row)) for row in cursor.fetchall()]
            
            # Ghee Coconut
            cursor.execute("SELECT * FROM temple_ghee_coconut_new WHERE date BETWEEN %s AND %s", [start_date, end_date])
            gc_data = [dict(zip([col[0] for col in cursor.description], row)) for row in cursor.fetchall()]
            
            # Maladharane
            cursor.execute("SELECT * FROM temple_maladharane_new WHERE date BETWEEN %s AND %s", [start_date, end_date])
            ml_data = [dict(zip([col[0] for col in cursor.description], row)) for row in cursor.fetchall()]
            
            # Irumudi
            cursor.execute("SELECT * FROM temple_irumudi_new WHERE date BETWEEN %s AND %s", [start_date, end_date])
            irumudi_data = [dict(zip([col[0] for col in cursor.description], row)) for row in cursor.fetchall()]
            
            # Donation
            cursor.execute("SELECT * FROM temple_donation_new WHERE date BETWEEN %s AND %s", [start_date, end_date])
            donation_data = [dict(zip([col[0] for col in cursor.description], row)) for row in cursor.fetchall()]
            
            # Materials
            cursor.execute("SELECT * FROM temple_materials_new WHERE date BETWEEN %s AND %s", [start_date, end_date])
            material_data = [dict(zip([col[0] for col in cursor.description], row)) for row in cursor.fetchall()]
            
            # UPI
            cursor.execute("SELECT * FROM temple_upi_new WHERE date BETWEEN %s AND %s", [start_date, end_date])
            upi_data = [dict(zip([col[0] for col in cursor.description], row)) for row in cursor.fetchall()]
            
            # Expense
            cursor.execute("SELECT * FROM temple_expense WHERE date BETWEEN %s AND %s", [start_date, end_date])
            expense_data = [dict(zip([col[0] for col in cursor.description], row)) for row in cursor.fetchall()]

        # Calculate totals with proper null handling
        grand_total = 0
        upi_total = 0
        expense_total = 0
        opening_balance = 0

        # Add opening balance
        if ob_data:
            opening_balance = float(ob_data[0].get('amount', 0) or 0)

        # Calculate grand total as sum of all income sources
        for item in gc_data:
            grand_total += float(item.get('total_cost', 0) or 0)
        
        for item in ml_data:
            grand_total += float(item.get('total_cost', 0) or 0)
        
        for item in irumudi_data:
            grand_total += float(item.get('amount', 0) or 0)
        
        for item in donation_data:
            grand_total += float(item.get('amount', 0) or 0)
        
        for item in material_data:
            grand_total += float(item.get('amount', 0) or 0)
        
        # Add opening balance to grand total
        grand_total += opening_balance
        
        # Calculate UPI and Expense totals
        for item in upi_data:
            upi_total += float(item.get('amount', 0) or 0)
        
        for item in expense_data:
            expense_total += float(item.get('amount', 0) or 0)

        # Calculate cash total: Grand total - (UPI + Expense)
        cash_total = grand_total - (upi_total + expense_total)

        # Format the response data
        response_data = {
            'status': 'success',
            'data': {
                'opening_balance': opening_balance,
                'gc': gc_data,
                'ml': ml_data,
                'irumudi': irumudi_data,
                'donation': donation_data,
                'material': material_data,
                'upi': upi_data,
                'expense': expense_data,
                'grand_total': round(grand_total, 2),
                'upi_total': round(upi_total, 2),
                'expense_total': round(expense_total, 2),
                'cash_total': round(cash_total, 2)
            }
        }
        return JsonResponse(response_data)

    except Exception as e:
        logger.error(f"Error in fetch_report_by_date: {str(e)}")
        return JsonResponse({'status': 'error', 'message': str(e)})

def report_by_date(request):
    return render(request, 'temple_app/report_by_date.html')

def fetch_report_by_month(request):
    try:
        month = request.GET.get('month')
        year = request.GET.get('year')
        
        if not month or not year:
            return JsonResponse({'status': 'error', 'message': 'Month and year are required'})

        # Fetch data from all tables for the selected month and year
        from .models import OB_new
        ob_data = list(OB_new.objects.filter(date__month=month, date__year=year).values())
        gc_data = list(ghee_coconut_new.objects.filter(date__month=month, date__year=year).values())
        ml_data = list(Maladharane_new.objects.filter(date__month=month, date__year=year).values())
        irumudi_data = list(Irumudi_new.objects.filter(date__month=month, date__year=year).values())
        donation_data = list(Donation_new.objects.filter(date__month=month, date__year=year).values())
        material_data = list(Materials_new.objects.filter(date__month=month, date__year=year).values())
        upi_data = list(UPI_new.objects.filter(date__month=month, date__year=year).values())
        expense_data = list(Expense.objects.filter(date__month=month, date__year=year).values())

        # Calculate totals with proper null handling
        grand_total = 0
        upi_total = 0
        expense_total = 0
        opening_balance = 0

        # Add opening balance
        if ob_data:
            opening_balance = float(ob_data[0].get('amount', 0) or 0)

        # Add up totals from each table
        for item in gc_data:
            grand_total += float(item.get('total_cost', 0) or 0)
        
        for item in ml_data:
            grand_total += float(item.get('total_cost', 0) or 0)
        
        for item in irumudi_data:
            grand_total += float(item.get('amount', 0) or 0)
        
        for item in donation_data:
            grand_total += float(item.get('amount', 0) or 0)
        
        for item in material_data:
            grand_total += float(item.get('amount', 0) or 0)
        
        for item in upi_data:
            upi_total += float(item.get('amount', 0) or 0)
        
        for item in expense_data:
            expense_total += float(item.get('amount', 0) or 0)

        response_data = {
            'status': 'success',
            'data': {
                'opening_balance': opening_balance,
                'gc': gc_data,
                'ml': ml_data,
                'irumudi': irumudi_data,
                'donation': donation_data,
                'material': material_data,
                'upi': upi_data,
                'expense': expense_data,
                'grand_total': round(grand_total, 2),
                'upi_total': round(upi_total, 2),
                'expense_total': round(expense_total, 2),
                'cash_total': round(grand_total - upi_total, 2),
                'final_cash_total': round(grand_total - upi_total + opening_balance, 2)
            }
        }
        return JsonResponse(response_data)

    except Exception as e:
        logger.error(f"Error in fetch_report_by_month: {str(e)}")
        return JsonResponse({'status': 'error', 'message': str(e)})

def delete_report_data(request):
    try:
        date_str = request.GET.get('date')
        table_type = request.GET.get('table_type')
        record_id = request.GET.get('record_id')
        
        if not date_str:
            return JsonResponse({'status': 'error', 'message': 'Date is required'})

        date = datetime.strptime(date_str, '%Y-%m-%d').date()
        
        # Delete specific record if table_type and record_id are provided
        if table_type and record_id:
            try:
                if table_type == 'ob':
                    from .models import OB_new
                    OB_new.objects.filter(date=date).delete()
                elif table_type == 'gc':
                    ghee_coconut_new.objects.filter(id=record_id, date=date).delete()
                elif table_type == 'ml':
                    Maladharane_new.objects.filter(id=record_id, date=date).delete()
                elif table_type == 'irumudi':
                    Irumudi_new.objects.filter(id=record_id, date=date).delete()
                elif table_type == 'donation':
                    Donation_new.objects.filter(id=record_id, date=date).delete()
                elif table_type == 'material':
                    Materials_new.objects.filter(id=record_id, date=date).delete()
                elif table_type == 'upi':
                    UPI_new.objects.filter(id=record_id, date=date).delete()
                elif table_type == 'expense':
                    Expense.objects.filter(id=record_id, date=date).delete()
                
                return JsonResponse({
                    'status': 'success',
                    'message': f'Successfully deleted record from {table_type} table'
                })
            except Exception as e:
                logger.error(f"Error deleting specific record: {str(e)}")
                return JsonResponse({
                    'status': 'error',
                    'message': f'Error deleting record: {str(e)}'
                })
        
        # If no specific record is provided, delete all data for the date
        from django.db import transaction
        
        with transaction.atomic():
            # Delete from each table
            from .models import OB_new
            OB_new.objects.filter(date=date).delete()
            ghee_coconut_new.objects.filter(date=date).delete()
            Maladharane_new.objects.filter(date=date).delete()
            Irumudi_new.objects.filter(date=date).delete()
            Donation_new.objects.filter(date=date).delete()
            Materials_new.objects.filter(date=date).delete()
            UPI_new.objects.filter(date=date).delete()
            Expense.objects.filter(date=date).delete()
            
            # Also delete from the main Report table
            Report.objects.filter(date=date).delete()
        
        return JsonResponse({
            'status': 'success',
            'message': f'Successfully deleted all data for date {date}'
        })
        
    except Exception as e:
        logger.error(f"Error in delete_report_data: {str(e)}")
        return JsonResponse({
            'status': 'error',
            'message': f'Error deleting data: {str(e)}'
        })
