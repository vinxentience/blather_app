class UnbordingContent {
  String image;
  String title;
  String description;

  UnbordingContent(
      {required this.image, required this.title, required this.description});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Chat with Friends',
      image: 'assets/images/chatting.svg',
      description: "With Blather you can chat your friends anytime, anywhere. "
          "This application is a great tool for finding friends and "
          "continue to grow your social circle. "),
  UnbordingContent(
      title: 'Connect with Friends',
      image: 'assets/images/connecting.svg',
      description:
          "This platform is perfect for connecting with your close friends "
          "with its very cool features. Talk about your interest, hobbies "
          "and share your best moments with other people. "),
  UnbordingContent(
      title: 'Interact with Friends',
      image: 'assets/images/videocall.svg',
      description: "Regardless of where you're located, you can interact "
          "with your friends in which can help improve communication "
          "and establish connections."),
  UnbordingContent(
      title: 'Join Us Now!',
      image: 'assets/images/joinus.svg',
      description:
          "Joining our community is easy, with no hassle. It only takes 1 step "
          "in order for you to utilize our service. To get started tap the "
          "button below."),
];
