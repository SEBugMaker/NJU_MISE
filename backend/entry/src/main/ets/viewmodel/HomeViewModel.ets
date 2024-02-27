import ItemData from '../common/bean/HomeItemData';

/**
 * Binds data to components and provides interfaces.
 */
export class MainViewModel {

  getSettingListData(): Array<ItemData> {
    let settingListData: ItemData[] = [
      new ItemData(('我的帖子'), $r('app.media.news')),
      new ItemData(('修改信息'), $r('app.media.data')),
      new ItemData(('调查反馈'), $r('app.media.target')),
      new ItemData(('会员中心'), $r('app.media.menu')),
      new ItemData(('关于我们'), $r('app.media.about'))
    ];
    return settingListData;
  }
}

export default new MainViewModel();