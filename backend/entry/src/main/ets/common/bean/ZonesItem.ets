/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Item info of the zones.
 */
export default class ZonesItem {
  id: number = 0;
  title: ResourceStr = $r('app.string.case_name_a');
  subTitle: ResourceStr = $r('app.string.case_sub_name_a');
  content: ResourceStr[] = [];
  thumbnail: string = 'https://ooo.0x0.ooo/2023/11/29/OrsAND.png';
  swiperPic: string = 'https://ooo.0x0.ooo/2023/11/29/OrsAND.png';
  subPicTop: ResourceStr = 'https://ooo.0x0.ooo/2023/11/29/OrsNd1.png';
  subPicBottom: ResourceStr = $r('app.media.case_subpictop_a');
  titleIcon: ResourceStr = $r('app.media.titleIcon');
  imageList: ResourceStr[] = [];
  buildingInformation: ResourceStr = $r('app.string.introduction_case_first_a');
  buildingPic: ResourceStr = $r('app.media.case_thumbnail_a');
  backgroundColor: ResourceStr = $r('app.color.light_blue');
  starLinePic: ResourceStr[] = [];
}