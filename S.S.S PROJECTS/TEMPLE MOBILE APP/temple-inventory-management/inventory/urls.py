from django.contrib import admin
from django.urls import path, include 
from temple import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('temple.urls')),  
    path('generator/', views.report_generator, name='report_generator'),
    path('viewer/', views.report_viewer, name='report_viewer'),
    path('save_report/', views.save_report, name='save_report'),
    path('fetch_report_by_date/', views.fetch_report_by_date, name='fetch_report_by_date'),
    path('fetch_report_by_month/', views.fetch_report_by_month, name='fetch_report_by_month'),
]

