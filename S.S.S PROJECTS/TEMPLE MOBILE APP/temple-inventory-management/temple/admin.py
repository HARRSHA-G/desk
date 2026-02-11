from django.contrib import admin
from .models import Donation_new,OB_new, Expenses, Irumudi_new, Maladharane_new, Materials_new, UPI_new, ghee_coconut_new, inventory_items_stock,Irumudi_bookig_receipt, Maaladharane, Ghee_Coconut, Temple_seva_receipt,Items_sold_rcpt, Daily_Expense,Donations
# Register your models here.
admin.site.register(inventory_items_stock)
admin.site.register(Irumudi_bookig_receipt)
admin.site.register(Maaladharane)
admin.site.register(Ghee_Coconut)
admin.site.register(Items_sold_rcpt)
admin.site.register(Temple_seva_receipt)
admin.site.register(Daily_Expense)
admin.site.register(Donations)
admin.site.register(Expenses)
admin.site.register(Maladharane_new)
admin.site.register(Irumudi_new)
admin.site.register(Donation_new)
admin.site.register(Materials_new)
admin.site.register(UPI_new)
admin.site.register(ghee_coconut_new)
admin.site.register(OB_new)
# The above code registers the models with the Django admin site, allowing them to be managed through the admin interface.   

