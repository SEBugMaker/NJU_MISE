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

import router from '@ohos.router';
import ZonesItem from '../common/bean/ZonesItem';
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import { ZonesConstants as ZoneConst } from '../common/constants/ZonesConstants';
import ZonesViewModel from '../viewmodel/ZonesViewModel';

@Component
export struct Zones {
  private changedIndex: boolean = true;
  private zonesList: ZonesItem[] = ZonesViewModel.getZonesList();
  @State aheadIndex: number = ZoneConst.HALF_COUNT;
  @State marginBottom: number = 0;



  startAnimation(isUp: boolean): void {
    animateTo({
      duration: Const.SWIPER_DURATION,
    }, () => {
      let dataLength = this.zonesList.length;
      let tempIndex = isUp ? this.aheadIndex + 1 : dataLength + this.aheadIndex - 1;
      this.aheadIndex = tempIndex % dataLength;
      this.marginBottom = 0;
    });
  }

  handlePanGesture(offsetY: number): void {
    if (Math.abs(offsetY) < ZoneConst.MAX_MOVE_OFFSET) {
      this.marginBottom = offsetY;
    } else {
      if (this.changedIndex) {
        return;
      }
      this.changedIndex = true;
      this.startAnimation(offsetY < 0);
    }
  }

  build() {
    // Navigation() {
      Swiper() {
        ForEach(this.zonesList, (item: ZonesItem, index?: number) => {
          Row() {
            Image(item.thumbnail)
          }
          //   ? 0 : ZoneConst.HALF_COUNT - Math.abs(this.getImgCoefficients(index)))
        }, (item: ZonesItem) => JSON.stringify(item))
      }
      .width(Const.FULL_PERCENT)
      .height(Const.FULL_PERCENT)
      .autoPlay(true)
      .onClick(() => {
        router.pushUrl({ url: Const.INTRODUCTION_URL, params: { id: this.zonesList[this.aheadIndex].id } });
      })
      .gesture(
        PanGesture({ direction: PanDirection.Vertical })
          .onActionStart((event: GestureEvent | undefined) => {
            if (!event) {
              return;
            }
            this.changedIndex = false;
            this.handlePanGesture(event.offsetY);
          })
          .onActionUpdate((event: GestureEvent | undefined) => {
            if (!event) {
              return;
            }
            this.handlePanGesture(event.offsetY);
          })
          .onActionEnd(() => {
            animateTo({
              duration: Const.SWIPER_DURATION,
            }, () => {
              this.marginBottom = 0;
            });
          })
      )
    //}
    .height(Const.PERCENTAGE_30)
    .backgroundColor($r('app.color.white'))
  }
}