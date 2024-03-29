import router from '@ohos.router';
import ZonesItem from '../common/bean/ZonesItem';
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import { DeviceScreen } from '../common/utils/DeviceScreen';
import { Animation } from '../common/utils/Animation';
import SwiperListItem from '../view/SwiperListItem';
import StyleListItem from '../view/StyleListItem';
import SubTitleItem from '../view/SubTitleItem';
import zonesViewModel from '../viewmodel/ZonesViewModel';
import { RouteTitle } from '../common/bean/TrainsMap';

@Entry
@Component
struct IntroductionPage {
  @State zoneList: ZonesItem[] = zonesViewModel.getZonesList();
  @Provide('introductionData') introductionData: ZonesItem = zonesViewModel.getZonesList()[0];
  @State currentZoneId: number = 0;
  @State screenHeight: number = 0;
  @State listPosition: number = Const.LIST_POSITION_BEGIN;
  @State imageHeight: number = Const.FULL_PERCENT_NUMBER;
  @State arrowIconOpacity: number = Const.OPACITY_MAX;
  @State isShowReplay: Array<boolean> = [];
  @State currentListIndex: number = Const.LIST_POSITION_BEGIN;
  @State offsetSum: number = 0;
  private scrollerForList: Scroller = new Scroller();
  @State scaleIcon: Array<number> = [Const.OPACITY_MAX, Const.OPACITY_MIN,
  Const.OPACITY_MIN];
  @State iconTitle: string = Const.ICON_SUBTITLE_ARRAY[0];
  @State isReachStart: boolean = false;
  @State geographicPicType: string = Const.GEOGRAPHY_LIGHT;
  @State buildingType: string = Const.BUILDING_TEXT;
  @State homeIconOpacity: number = Const.OPACITY_MIN;

  @Builder
  TitleIcon($$: RouteTitle) {
    Column() {
      Image($$.src)
        .width($r('app.float.title_icon_width'))
        .height($r('app.float.title_icon_height'))
        .scale({ x: $$.scale })
        .opacity($$.scale)
        .animation({
          duration: Const.TITLE_ICON_ANIMATION_DURATION,
          curve: Curve.EaseOut
        })
    }
  }

  @Builder
  StickyHeader() {
    Column() {
      Stack({ alignContent: Alignment.Top }) {
        Image(this.introductionData.titleIcon)
          .height($r('app.float.introduction_title_icon_height'))
          .width($r('app.float.introduction_title_icon_width'))
          .margin({ bottom: $r('app.float.title_icon_margin_bottom') })

        this.TitleIcon({ src: $r('app.media.titleIcon'), scale: this.scaleIcon[0] })
      }
      .width(Const.FULL_SIZE)
      .height($r('app.float.stack_container_height'))

      Text(this.iconTitle)
        .fontSize($r('app.float.font_size_smaller'))
        .height($r('app.float.font_height_smaller'))
        .fontColor($r('app.color.font_color_black'))
        .opacity(Const.FONT_COLOR_OPACITY_NORMAL)
        .margin({ bottom: $r('app.float.icon_title_margin_bottom') })
        .fontWeight(FontWeight.Bold)
    }
    .width(Const.FULL_SIZE)
    // .backgroundColor(Color.Pink)
    .backgroundColor($r('app.color.start_window_background'))
    .height(Const.STICKY_HEIGHT)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  StickyFooter() {
    Column()
      .height($r('app.float.introduction_page_padding_bottom'))
  }

  /**
   * The transition animation from page to page.
   */
  pageTransition() {
    PageTransitionEnter({ duration: Const.SHARED_DURATION })
      .slide(SlideEffect.Bottom)
      .scale({
        x: 0,
        y: 0,
        z: 0,
        centerX: Const.HALF_PERCENT,
        centerY: Const.HALF_PERCENT
      })
    PageTransitionExit({ delay: Const.SWIPER_DURATION })
      .slide(SlideEffect.Bottom)
      .scale({
        x: 0,
        y: 0,
        z: 0,
        centerX: Const.HALF_PERCENT,
        centerY: Const.HALF_PERCENT
      })
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Bottom }) {
        Column() {
          List({ scroller: this.scrollerForList }) {
            ListItem() {
              SwiperListItem({
                imageHeight: this.imageHeight,
                currentZoneId: this.currentZoneId,
                arrowIconOpacity: this.arrowIconOpacity
              })
            }

            // ListItem() {
            //   SubTitleItem()
            // }

            ListItemGroup({ header: this.StickyHeader(), footer: this.StickyFooter() }) {
              ListItem() {
                StyleListItem()
              }
            }
          }
          .width(Const.FULL_SIZE)
          .height(Const.FULL_SIZE)
          .edgeEffect(EdgeEffect.None)
          .scrollBar(BarState.Off)
          .sticky(StickyStyle.Header)
          .onReachStart(() => {
            this.resetParameters();
          })
          .onScrollIndex((start: number) => {
            this.currentListIndex = start;
          })
          .onReachEnd(() => {
            this.listPosition = Const.LIST_POSITION_END;
          })
          .onScroll(() => {
            this.startAnimation();
          })
          .onScrollFrameBegin((offset: number, state: ScrollState) => {
            let realOffset = Animation.controlImageScale(this, offset, state);
            return { offsetRemain: realOffset };
          })
        }
        .height(Const.FULL_SIZE)

        Image($r('app.media.ic_home_back'))
          .height($r('app.float.page_icon_size'))
          .aspectRatio(1)
          .margin({ bottom: $r('app.float.up_icon_margin_bottom'), left: $r('app.float.page_icon_margin_vertical') })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/HealthManager'
            })
          })
          .opacity(1 - this.arrowIconOpacity)

        // Image($r('app.media.ic_home_back'))
        //   .height($r('app.float.page_icon_size'))
        //   .aspectRatio(1)
        //   .margin({
        //     right: $r('app.float.page_icon_margin_vertical'),
        //     bottom: this.screenHeight - Const.HOME_ICON_MARGIN_TOP
        //   })
        //   .onClick(() => {
        //     url: 'pages/HealthManager'
        //   })
      }
      .backgroundColor($r('app.color.white'))
      .height(Const.FULL_SIZE)
    }
    .height(Const.FULL_SIZE)
  }

  aboutToAppear() {
    // 整改后的代码
    let params = router.getParams() as Record<string, Object>;
    this.currentZoneId = params.id as number;

    this.getIntroductionData();
    this.screenHeight = DeviceScreen.getDeviceHeight();
  }

  /**
   * Get the introduction by currentZoneId.
   */
  getIntroductionData() {
    this.introductionData = this.zoneList.filter((item) => item.id === this.currentZoneId)[0];
  }

  /**
   * Reset all parameters if the list arrive begin by animation.
   */
  resetParameters() {
    this.listPosition = Const.LIST_POSITION_BEGIN;
    if (this.listPosition === Const.LIST_POSITION_BEGIN && this.isReachStart) {
      this.imageHeight = Const.FULL_PERCENT_NUMBER;
      this.arrowIconOpacity = Const.OPACITY_MAX;
    }
    this.isReachStart = false;
  }

  /**
   * Start animation when scroll the list.
   */
  startAnimation() {
    Animation.changeTitleIcon(this);
  }

  /**
   * Click the up arrow scroll to the beginning.
   */
  scrollToTop() {
    if (this.listPosition !== Const.LIST_POSITION_BEGIN) {
      this.scrollerForList.scrollTo({
        xOffset: 0,
        yOffset: Const.SCROLL_UP_TOP_THRESHOLD,
        animation: {
          duration: this.offsetSum / Const.OFFSET_DIVIDE_RATIO,
          curve: Curve.Linear,
        }
      })
      this.isReachStart = true;
    } else {
      this.imageHeight = Const.FULL_PERCENT_NUMBER;
      this.arrowIconOpacity = Const.OPACITY_MAX;
    }
  }
}