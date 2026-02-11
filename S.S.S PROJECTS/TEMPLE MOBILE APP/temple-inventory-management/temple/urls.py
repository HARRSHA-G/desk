from django.contrib import admin
from django.urls import path
from . import views
urlpatterns = [
    path('',views.home,name="index"),
    path('update_items/',views.add_items,name='update'),
    path('irumudi_recepit/',views.irumudi_book,name='irumudi_book'),
    path('irumudi_items/',views.items_list_,name='item_lists'),
    path('maaladharane_receipt/',views.maaladharane,name='maaladharane'),
    path('ghee_coconut_receipt/',views.ghee,name='ghee'),
    path('irumudi_record/',views.irumudi_register,name='irumudi_register'),
    path('cash_report/',views.expenses,name='expenses'),
    path("expenditure",views.expense,name="exp_entry"),
    path('schd_dates/', views.scheduled_irumudi ,name='scheduled_list'),
    # path('irumudi_record/irumudi_record/', views.record_tabel ,name='records_page'),
    path('pdf/',views.generate_pdf,name="gen_pdf"),
    path('donations/',views.donate,name="donate"),
    path('get_irumudi_details/', views.get_irumudi_details, name='get_irumudi_details'),
    path('Calculator/',views.Calculator,name="calculator"),
    path('save_report/', views.save_report, name='save_report'),
    path('report_generator/', views.report_generator, name='report_generator'),
    path('report_viewer/', views.report_viewer, name='report_viewer'),
    path('fetch_report_by_date/', views.fetch_report_by_date, name='fetch_report_by_date'),
    path('fetch_report_by_month/', views.fetch_report_by_month, name='fetch_report_by_month'),
    path('report_by_date/', views.report_by_date, name='report_by_date'),
    path('delete-report-data/', views.delete_report_data, name='delete_report_data'),
]

