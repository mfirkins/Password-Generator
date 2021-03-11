from django.shortcuts import render
from django.http import HttpResponse
import random

# Create your views here.

def home(request):
    return render(request, 'generator/home.html')

def about(request):
    return render(request, 'generator/about.html')

def password(request):
    genresult = ""
    characters = list('abcdefghijklmnopqrstuvwxyz')
    reqLength = int(request.GET.get('length',12))
    reqUppercase = request.GET.get('uppercasechar')
    reqSpecial = request.GET.get('specialchar')
    reqNumbers = request.GET.get('numberchar')
    if reqUppercase:
        characters.extend(list('ABCDEFGHIJKLMNOPQRSTUVWXYZ'))
    if reqSpecial:
        characters.extend(list('!@#£$()&%^*'))
    if reqNumbers:
        characters.extend(list('0123456789'))
    for x in range(reqLength):
        genresult += random.choice(characters)

    return render(request, 'generator/password.html', {'password':genresult})
