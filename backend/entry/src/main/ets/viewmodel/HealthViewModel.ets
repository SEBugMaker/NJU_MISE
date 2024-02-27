import ItemData from '../common/bean/HealthItemData';

/**
 * Binds data to components and provides interfaces.
 */
export class HealthViewModel {

  getGridData(): Array<ItemData> {
    let  GridData: ItemData[] = [
      new ItemData("体重"),
      new ItemData("身高"),
      new ItemData("血压"),
      new ItemData("血糖"),
      new ItemData("心率" ),
      new ItemData("今日运动量" )
    ];
    return  GridData;
  }


}

export default new HealthViewModel();