import UserQuestionItem from '../common/bean/UserQuestionItem';


class UserQuestionViewModel {
  getList(): UserQuestionItem[] {
    return defaultList;
  }

  getByIndex(index: number): UserQuestionItem {
    return defaultList[index];
  }

  addItem(content_new: string):void{
    let oldList = userQuestionViewModel.getList();
    let newItem = new UserQuestionItem();
    newItem.id = oldList.length;
    newItem.content = content_new;
    oldList.push(newItem);
  }
}

let userQuestionViewModel = new UserQuestionViewModel();

export default userQuestionViewModel as UserQuestionViewModel;

const defaultList: UserQuestionItem[] = [
  {
    id: 0,
    content: "你好，我是你的医疗助手，请告诉我你的问题",
    question: false
  }
]
