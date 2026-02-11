from django.db import models

class Profile(models.Model):
    name = models.CharField(max_length=100, default="Harsha Vardhan")
    surname = models.CharField(max_length=100, default="Gadde")
    role = models.CharField(max_length=100, default="Full Stack Developer")
    bio = models.TextField()
    about_image = models.ImageField(upload_to='profile/', blank=True, null=True)
    cv_link = models.URLField(blank=True, null=True)
    email = models.EmailField(default="gaddeharshav@gmail.com")
    phone = models.CharField(max_length=20, default="+91 9392 441826")
    location = models.CharField(max_length=100, default="Vijayawada, India")
    
    # Dynamic Section Text
    hero_subtitle = models.CharField(max_length=100, default="Who Am I")
    hero_title = models.CharField(max_length=100, default="The Developer")
    contact_text = models.TextField(default="Ready to build something extraordinary? Send me a message and let's start the conversation.")

    # Dynamic SEO & Meta Tags
    seo_title = models.CharField(max_length=200, default="Harsha Vardhan Gadde | Full Stack Developer Portfolio")
    seo_description = models.TextField(default="Portfolio of Harsha Vardhan Gadde - Full Stack Developer specializing in Python, Django, JavaScript, and Cloud Technologies.")
    seo_keywords = models.TextField(default="Harsha Vardhan Gadde, Full Stack Developer, Python, Django, Portfolio")
    
    def __str__(self):
        return f"{self.name} {self.surname}"

class Education(models.Model):
    degree = models.CharField(max_length=200)
    institution = models.CharField(max_length=200)
    institution_url = models.URLField(blank=True)
    years = models.CharField(max_length=50)
    status = models.CharField(max_length=100, blank=True) # e.g., "Pursuing" or "CGPA : 8.0/10"
    order = models.IntegerField(default=0)

    class Meta:
        ordering = ['order']

    def __str__(self):
        return self.degree

class Experience(models.Model):
    role = models.CharField(max_length=200)
    company = models.CharField(max_length=200)
    company_url = models.URLField(blank=True)
    duration = models.CharField(max_length=100)
    description = models.TextField()
    skills_used = models.CharField(max_length=500, help_text="Comma separated skills")
    icon_class = models.CharField(max_length=50, default="fas fa-laptop-code")
    order = models.IntegerField(default=0)

    class Meta:
        ordering = ['order']

    def __str__(self):
        return f"{self.role} at {self.company}"

class Project(models.Model):
    title = models.CharField(max_length=200)
    description = models.TextField()
    link = models.URLField(blank=True)
    tech_stack = models.CharField(max_length=500, help_text="Comma separated technologies")
    order = models.IntegerField(default=0)

    class Meta:
        ordering = ['order']

    def __str__(self):
        return self.title

class Skill(models.Model):
    name = models.CharField(max_length=100)
    icon_class = models.CharField(max_length=50, help_text="FontAwesome class (e.g., fab fa-python)")
    order = models.IntegerField(default=0)

    class Meta:
        ordering = ['order']

    def __str__(self):
        return self.name

class Achievement(models.Model):
    title = models.CharField(max_length=200)
    year = models.CharField(max_length=50)
    description = models.TextField()
    icon_class = models.CharField(max_length=50, default="fas fa-trophy")
    order = models.IntegerField(default=0)

    class Meta:
        ordering = ['order']
        
    def __str__(self):
        return self.title

class SocialLink(models.Model):
    platform = models.CharField(max_length=50)
    icon_class = models.CharField(max_length=50)
    url = models.URLField()
    order = models.IntegerField(default=0)

    class Meta:
        ordering = ['order']

    def __str__(self):
        return self.platform
