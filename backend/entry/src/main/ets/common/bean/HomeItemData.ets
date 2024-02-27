export default class PageResource {
  /**
   * Text of list item.
   */
  title: string;
  /**
   * Image of list item.
   */
  img: Resource;
  /**
   * Other resource of list item.
   */
  others?: Resource;

  constructor(title: string, img: Resource, others?: Resource) {
    this.title = title;
    this.img = img;
    this.others = others;
  }
}