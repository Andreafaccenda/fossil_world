class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent({required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Guida per la cattura dei fossili',
      image: 'assets/image/quality.svg',
      discription: "Quando sarai nelle cordinate geografiche del fossili,ti apparirà un messaggio che ti comunicherà la presenza del fossile "
  ),
  UnbordingContent(
      title: 'Identificazione del piano',
      image: 'assets/image/quality.svg',
      discription: "Una volta che ti troverai nei pressi del fossili,l'applicazione individuerà un piano su cui verrà piazzato il fossile"
  ),
  UnbordingContent(
      title: 'Ancoraggio del fossile',
      image: 'assets/image/delevery.svg',
      discription: "Individuato il piano,sarai tu utente a scegliere dove piazzare il fossile cliccando su un nodo del piano"
  ),
  UnbordingContent(
      title: 'Cattura del fossile',
      image: 'assets/image/reward.svg',
      discription: "Una volta che il fossile è apparso,per procedere alla cattura basterà avvicinarsi lentamente e quando sarai molto vicino il fossile sarà catturato"
  ),
];