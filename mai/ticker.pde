class TickerBar {

  String[] messages = {
    "Breaking News: AI students spotted coding with ocean views in Figueira da Foz.",
    "Just In: New Master’s in Artificial Intelligence rolls out — directly onto the beach.",
    "Newsflash: Surfboards and neural networks collide on Portugal’s west coast.",
    "Developing Story: The future of AI might be wearing sunglasses and flip-flops.",
    "Live Update: Coastal town becomes unexpected hotspot for machine learning minds.",
    "Breaking: A Master’s that teaches AI and sun safety — now enrolling.",
    "Intelligence Alert: Brainwaves rising with the tide in Figueira da Foz.",
    "Confirmed: AI now stands for Atlantic Intelligence — study begins this autumn.",
    "Hot Off the Press: Portugal launches seaside AI programme; sunscreen stocks soar.",
    "Urgent Bulletin: Students caught training models and catching waves.",
    "Developing: Beachfront laptops overheating from GPU use — and sunshine.",
    "Midday Report: Algorithmic thinking pairs well with iced coffee by the sea.",
    "Anchored in Facts: AI curriculum sets sail from Figueira — with coastal winds at its back.",
    "Summer Special: Reinforcement learning spotted reinforcing tans.",
    "News Desk Update: Figueira da Foz officially becomes Europe’s chillest AI capital.",
    "Investigation Underway: Are AI breakthroughs more likely with ocean air?",
    "On the Record: “I chose the course for the syllabus — and the sunsets,” says student.",
    "Trending: Applications to study AI spike wherever there’s surf.",
    "Experts Say: Machine learning thrives on clear skies and clear minds.",
    "End of Day Summary: Code compiles smoother when the horizon’s this pretty."
  };
  String urlMessage = "Find out more at dei.uc.pt/mia";

  PImage qrCode = loadImage("qrcode/qrcode-white.png");
  PFont textFont = null;

  float barHeight;
  float scrollSpeed;
  float textHeight;
  float qrCodeHeight;
  float qrCodeMargin;

  ArrayList<ScrollingItem> items = new ArrayList<ScrollingItem>();
  int nextMessageIndex = 0;

  TickerBar(float relativeHeight, float scrollSpeed) {
    this.barHeight = height * relativeHeight;
    this.scrollSpeed = scrollSpeed;

    textHeight = 0.6 * this.barHeight;
    qrCodeHeight = 0.8 * this.barHeight;
    qrCodeMargin = textHeight * 2;

    if (qrCode.height > qrCodeHeight) {
      qrCode.resize((int) qrCodeHeight, (int) (qrCode.width * (qrCodeHeight / qrCode.height)));
    }

    textFont = createFont("fonts/Everett-Regular.otf", round(textHeight));

    ArrayList<String> messagesMod = new ArrayList<String>();
    for (int i = 0; i < messages.length; i++) {
      messagesMod.add(messages[i]);
      if ((i + 1) % 3 == 0) {
        messagesMod.add(urlMessage);
      }
    }
    messages = messagesMod.toArray(new String[0]);

    while (true) {
      ScrollingItem item = addNextMessage();
      if (item.getRight() > width) {
        break;
      }
    }
  }

  void update() {
    for (int i = items.size() - 1; i >= 0; i--) {
      items.get(i).x -= scrollSpeed;
      if (items.get(i).getRight() < 0) {
        items.remove(i);
      }
    }
    if (items.size() > 0) {
      ScrollingItem lastItem = items.get(items.size() - 1);
      if (lastItem.getRight() < width) {
        addNextMessage();
      }
    }
  }

  void display() {
    float barY = height - barHeight;
    float barCenterY = barY + barHeight / 2f;

    pushStyle();
    fill(0);
    noStroke();
    rect(0, barY, width, barHeight);

    textFont(textFont);
    textAlign(LEFT, CENTER);
    fill(255);
    for (ScrollingItem item : items) {
      float qrCodeX = item.x + qrCodeMargin;
      image(qrCode, qrCodeX, barCenterY - qrCode.height / 2f);
      float textX = qrCodeX + qrCode.width + qrCodeMargin;
      text(item.message, textX, barCenterY - textHeight * 0.1);
    }
    popStyle();
  }

  ScrollingItem addNextMessage() {
    float x = 0;
    if (items.size() > 0) {
      x = items.get(items.size() - 1).getRight();
    }
    String message = messages[nextMessageIndex % messages.length];
    nextMessageIndex = (nextMessageIndex + 1) % messages.length;

    pushStyle();
    textFont(textFont);
    float messageWidth = textWidth(message + "mn");
    popStyle();
    float itemWidth = qrCodeMargin + qrCode.width + qrCodeMargin + messageWidth;

    ScrollingItem item = new ScrollingItem(message, x, itemWidth);
    items.add(item);
    return item;
  }
}


class ScrollingItem {
  String message;
  float x;
  float w;
  float w2;

  ScrollingItem(String message, float x, float w) {
    this.message = message;
    this.x = x;
    this.w = w;
  }

  float getRight() {
    return x + w;
  }
}
