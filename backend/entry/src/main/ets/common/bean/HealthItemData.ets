
/**
 * List item data entity.
 */
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

  constructor(title: string,others?: Resource) {
    this.title = title;
    this.others = others;
  }
}