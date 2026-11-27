MUBAIRA MOTORS SITE: ADDING CARS AND IMAGES (no code editing)
=============================================================
Workflow: add or change car folders -> double-click update-cars.bat -> open index.html.
(Windows only. update-cars.bat needs build-cars.ps1 beside it. Keep both in the site folder.)

CAR FOLDERS  (images\cars\)
  The folder you put a car in decides where it appears on the site:

  images\cars\family\                 -> Families
  images\cars\everyday\               -> Everyday drivers
  images\cars\business\transport\     -> Business, "Passenger transport" tab
  images\cars\business\trucks\        -> Business, "Trucks and construction" tab

  Make one folder per car, named:   YEAR Make Model
  Examples:  2016 Toyota Hiace Super GL     2015 Nissan X-Trail     2012 Scania R-Series Tipper
  (Year first, then make, then model. Spaces and capitals are fine. This name is shown on the site.)

  Inside each car folder put:
    main.jpg    the photo (landscape, about 1200x900, under 300 KB)
    info.txt    the details, one per line (see below)

EXTRA PHOTOS AND THE DETAILS PAGE
  Clicking a car opens its details page. Every photo in the car's folder appears in that page's gallery.
  main.jpg is the photo used on the card and shown first. Add more as anything.jpg (front.jpg, interior.jpg, back.jpg...).
  Photos are shown in alphabetical order after main.jpg. Use .jpg, .jpeg, .png or .webp.
  After adding photos, run update-cars.bat again.

SAME MODEL IN DIFFERENT COLOURS
  Make a separate folder for each one and put the colour in the name:
    2015 Honda Fit Pearl White      2015 Honda Fit Silver      2015 Honda Fit Blue
  Each has its own photos, price and mileage. On the details page, cars with the same year, make and
  model are listed under "More like this" so visitors can jump between colours.

CATEGORY TILE PHOTOS
  images\categories\family.jpg, everyday.jpg, business.jpg are the three big tiles at the top (about 900x700).
  The text sits over the bottom of the photo, so keep the vehicle in the upper-middle.

INFO.TXT  (plain Notepad file, name it exactly info.txt)
    type=SUV
    km=72000
    price=7500
    sold_month=2
    sold_year=11
  type        label above the car name (Sedan, SUV, Van, Tipper...). Optional.
  km          mileage. Optional.
  price       the BE FORWARD price in dollars. The site adds the 5% itself. If missing, the card says "Ask us".
  color        colour, shown on the details page. Optional.
  transmission Automatic or Manual. Optional.
  fuel         Petrol, Diesel, Hybrid... Optional.
  engine       for example 1.3L. Optional.
  seats        for example 7. Optional.
  description  one or two sentences about the car. Optional.
  sold_month  how many of this model you sold this month  } used for "Our most bought".
  sold_year   how many you sold this year                 } Optional, default 0.

MOVING A CAR TO ANOTHER CATEGORY: move its folder, then run update-cars.bat.
REMOVING A CAR: delete its folder, then run update-cars.bat.

DELIVERED AND HAPPY SECTION  (images\delivered\)
  One folder per delivery. Start the folder name with the date so the newest shows first:
    images\delivered\2026-11 Tendai M - Hiace\
  Inside put the handover photo (photo.jpg) and an info.txt:
    client=Tendai M.
    city=Harare
    date=November 2026
    car=2016 Toyota Hiace Super GL
    quote=Smooth from payment to delivery. The van arrived exactly as promised.
  MORE PHOTOS AND VIDEOS: put as many as you like in the same delivery folder (photos .jpg/.jpeg/.png/.webp,
  videos .mp4/.webm/.m4v). The card shows photo.jpg and a "3 photos, 1 video" tag. Clicking the card opens
  a viewer with every photo and video, the client's words, and a "Get a delivery like this" WhatsApp button.
  Keep videos short (under about 30 seconds, ideally under 20 MB, MP4 H.264) so the page stays fast.
  All lines are optional. Then run update-cars.bat. The first 6 show, with a "Show more deliveries" button for the rest.
  Loose photos placed directly in images\delivered\ (like delivered-01.jpg) are turned into their own folder by
  update-cars.bat, with an empty info.txt next to the photo. Open that info.txt, fill in the lines, and run the .bat again.
  Only use real client names and quotes, and ask the client's permission first.
  The two sample folders are placeholders: delete them.

OTHER IMAGES  (all optional, lowercase, .jpg)
    images\hero\hero.jpg                                 wide photo behind the top of the page (about 1920x1000)
    images\categories\family.jpg  everyday.jpg  business.jpg   the three big tiles (about 900x700)

NOTES
  Missing images show a navy and gold placeholder, so you can add them gradually.
  If something does not update, press Ctrl+F5 in the browser.
  Settings at the top of the script in index.html: WA (your WhatsApp number) and MARKUP (1.05 = +5%).
  The 12 folders included are samples with made-up prices. Delete them and add your real cars.
