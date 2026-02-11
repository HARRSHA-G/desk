from django.shortcuts import render
from .models import Profile, Education, Experience, Project, Skill, Achievement, SocialLink

def home(request):
    profile = Profile.objects.first()
    educations = Education.objects.all()
    experiences = Experience.objects.all()
    projects = Project.objects.all()
    skills = Skill.objects.all()
    achievements = Achievement.objects.all()
    social_links = SocialLink.objects.all()

    context = {
        'profile': profile,
        'educations': educations,
        'experiences': experiences,
        'projects': projects,
        'skills': skills,
        'achievements': achievements,
        'social_links': social_links,
    }
    return render(request, 'index.html', context)
