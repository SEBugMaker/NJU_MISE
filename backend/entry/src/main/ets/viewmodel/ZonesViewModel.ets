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

import ZonesItem from '../common/bean/ZonesItem';

class ZonesViewModel {
  getZonesList(): ZonesItem[] {
    return defaultList;
  }

  getZonesByIndex(index: number): ZonesItem {
    return defaultList[index];
  }
}

let zonesViewModel = new ZonesViewModel();

export default zonesViewModel as ZonesViewModel;

const defaultList: ZonesItem[] = [
  {
    id: 0,
    title: $r('app.string.case_name_a'),
    subTitle: $r('app.string.case_sub_name_a'),
    thumbnail: 'https://wx3.sinaimg.cn/mw690/008vzrKlgy1hki5nre173j30cy08q0td.jpg',
    swiperPic: 'https://wx1.sinaimg.cn/mw690/008vzrKlgy1hki48betnfj30k00fc0ub.jpg',
    content: [$r('app.string.introduction_case_first_a'), $r('app.string.introduction_case_second_a')],
    subPicTop: $r('app.media.case_subpictop_a'),
    subPicBottom: $r('app.media.case_subpictop_a'),
    titleIcon: $r('app.media.titleIcon'),
    imageList: [$r('app.media.list_a_1'),
                'https://wx2.sinaimg.cn/mw690/008vzrKlgy1hkqtimszowj30go0wsaen.jpg',
                'https://wx1.sinaimg.cn/mw690/008vzrKlgy1hkqtiebddgj30u017744f.jpg',
                'https://wx1.sinaimg.cn/mw690/008vzrKlgy1hkqtjyfazyj30hs10k0we.jpg'],
    buildingInformation: $r('app.string.case_sub_name_a'),
    buildingPic: $r("app.media.case_thumbnail_a"),
    backgroundColor: $r('app.color.white'),
    starLinePic: [$r("app.media.starline")]
  },
  {
    id: 1,
    title: '烫伤',
    subTitle: "一种皮肤组织损伤",
    thumbnail: 'https://wx1.sinaimg.cn/mw690/008vzrKlgy1hki5iq9vusj316g0u075h.jpg',
    swiperPic: 'https://wx4.sinaimg.cn/mw690/008vzrKlgy1hkqupct83dj30k00b9glq.jpg',
    content: ["烫伤是由于接触热液体、蒸汽、热气、固体或其他热源而引起的皮肤组织损伤。烫伤的严重程度分为三度：\n一度烫伤： 仅涉及表皮，表现为红肿、疼痛，无水泡形成。\n二度烫伤： 涉及表皮和真皮层，表现为红肿、疼痛，可能有水泡形成。\n三度烫伤： 涉及表皮、真皮和皮下组织，表面可能呈现白色或棕色，损伤较为深刻，通常伴随疼痛或无痛。",
              "急救方法：\n冷却受伤区域： 立即将受伤部位放在冷水中，或者使用冰块包裹（注意避免直接接触冰块皮肤）。持续冷却15-20分钟，有助于降低伤口温度，减轻疼痛。\n移除紧身衣物： 尽量避免在受伤区域戴上紧身衣物，因为烫伤可能引起肿胀。\n不要用冷水： 避免使用极冷的水，因为过于低温的水可能导致进一步的组织损伤。",
              "在烫伤的处理过程中，如果症状严重或恶化，建议立即就医寻求专业帮助。不同程度的烫伤需要不同的处理方法，因此具体的治疗应根据烫伤的程度和具体情况而定。"],
    subPicTop: $r('app.media.case_subpictop_a'),
    subPicBottom: $r('app.media.case_subpictop_a'),
    titleIcon: $r('app.media.titleIcon'),
    imageList: ['https://wx2.sinaimg.cn/mw690/008vzrKlgy1hkqt1r8ndbj30hs0mjaaw.jpg',
                'https://wx4.sinaimg.cn/mw690/008vzrKlgy1hkqt1v8u89j30hs0td3zw.jpg',
                'https://wx4.sinaimg.cn/mw690/008vzrKlgy1hkqt1zi1wvj30hs0quabt.jpg',
                'https://wx2.sinaimg.cn/mw690/008vzrKlgy1hkqt23n7vsj30hs0ltdh6.jpg'],
    buildingInformation: "一种皮肤组织损伤",
    buildingPic: $r("app.media.case_thumbnail_a"),
    backgroundColor: $r('app.color.white'),
    starLinePic: [$r("app.media.starline")]
  },
  {
    id: 2,
    title: '扭伤',
    subTitle: "关节周围软组织过度拉伸或扭曲",
    thumbnail: 'https://wx1.sinaimg.cn/mw690/008vzrKlgy1hki5igig3sj30dw09gaaf.jpg',
    swiperPic: 'https://wx3.sinaimg.cn/mw690/008vzrKlgy1hkqucp6wcvj30go09d3yu.jpg',
    content: ["扭伤是指关节周围的软组织（如韧带、肌肉和肌腱）因超过正常范围的运动而受到过度拉伸或扭曲，导致损伤的情况。扭伤通常会引起疼痛、肿胀和活动受限等症状。",
              "以下是一些预防措施：\n热身运动： 在进行任何体育活动之前，进行适当的热身运动可以增加关节的灵活性，减少受伤的风险。\n适当装备： 使用适当的运动鞋和其他保护设备，如护膝、护腕等，可以提供额外的支持和稳定性。\n强化肌肉： 维持良好的肌肉强度和平衡有助于保护关节，减少扭伤的可能性。\n注意环境： 在不平整的地面上行走或运动时要格外小心，以避免因摔倒而导致扭伤。",
              "如何治疗扭伤：\n休息： 休息是最基本也是最重要的治疗步骤之一。受伤的部位需要时间来愈合，避免使受伤部位过度使用。\n冰敷： 在休息的同时，冰敷受伤部位有助于减轻肿胀和疼痛。冰敷时间一般为每次15-20分钟，每2-3小时一次。\n绷带和抬高： 使用压缩绷带包扎受伤部位，有助于减轻肿胀。抬高受伤部位也可以有助于减少肿胀。\n药物治疗： 非处方药物如布洛芬（ibuprofen）或对乙酰氨基酚（acetaminophen）可以缓解疼痛和减轻炎症。\n物理治疗： 在一些情况下，物理治疗可以帮助恢复受伤部位的功能，加速康复过程。\n专业医疗： 严重的扭伤可能需要专业医生的治疗，有时可能需要手术干预。"],
    subPicTop: $r('app.media.case_subpictop_a'),
    subPicBottom: $r('app.media.case_subpictop_a'),
    titleIcon: $r('app.media.titleIcon'),
    imageList: ['https://wx3.sinaimg.cn/mw690/008vzrKlgy1hkqu5zma0uj30u01egah2.jpg',
                'https://wx3.sinaimg.cn/mw690/008vzrKlgy1hkqu64eqp5j30u01ckgs4.jpg',
                'https://wx4.sinaimg.cn/mw690/008vzrKlgy1hkqt6reaqwj30dw0iu0tt.jpg',
                'https://wx3.sinaimg.cn/mw690/008vzrKlgy1hkqt6ds7gfj30dw0fimzg.jpg'],
    buildingInformation: "关节周围软组织过度拉伸或扭曲",
    buildingPic: $r("app.media.case_thumbnail_a"),
    backgroundColor: $r('app.color.white'),
    starLinePic: [$r("app.media.starline")]
  },
  {
    id: 3,
    title: '腹泻',
    subTitle: "一种常见由感染引起的疾病",
    thumbnail: 'https://wx2.sinaimg.cn/mw690/008vzrKlgy1hki5m6gzx6j30zk0pp418.jpg',
    swiperPic: 'https://wx4.sinaimg.cn/mw690/008vzrKlgy1hkquea2c4aj30ra0i6wg0.jpg',
    content: ["腹泻是指排便次数明显增多，便便呈液体状或半流质状的症状。腹泻通常是由于肠道感染、食物中毒、药物反应、过敏、疾病或其他一些因素引起的。以下是腹泻的常见原因：\n感染性原因： 细菌、病毒、寄生虫感染是最常见的腹泻原因，如细菌性食物中毒、病毒性胃肠炎等。\n食物过敏： 对某些食物过敏或不耐受可能引起腹泻，典型的例子包括乳糖不耐受。\n药物反应： 某些药物的副作用可能导致腹泻，特别是抗生素和某些抗生素。\n炎症性肠病： 如克罗恩病和溃疡性结肠炎，可以引起慢性腹泻。\n肠易激综合症： 腹泻是其常见症状之一，伴随着腹痛、胀气等。\n水果或蔬菜中毒： 某些食物中的有毒物质可能导致急性腹泻。",
              "以下是一些常见的治疗方法：\n补充水分和电解质： 腹泻会导致大量水分和电解质的丢失，因此补水至关重要。口服含有盐分和糖分的电解质溶液（口服补液盐）是有效的方法。\n饮食调整： 避免摄入刺激性食物，如辛辣食物、咖啡、酒精，选择清淡易消化的食物，如米饭、面包、香蕉等。\n药物治疗： 对于感染性腹泻，医生可能会开具抗生素。对于非感染性腹泻，使用抗腹泻药物可能有助于缓解症状，但需在医生建议下使用。\n注意休息： 适当休息有助于恢复体力和加速康复。\n医学评估： 如果腹泻持续时间较长、伴有其他严重症状，或者对治疗不敏感，建议就医，以便进行进一步的评估和治疗。"],
    subPicTop: 'https://ooo.0x0.ooo/2023/11/29/OrsNd1.png',
    subPicBottom: 'https://ooo.0x0.ooo/2023/11/29/OrsNd1.png',
    titleIcon: $r('app.media.titleIcon'),
    imageList: ['https://wx3.sinaimg.cn/mw690/008vzrKlgy1hkqu48mdq9j30hs12ltbo.jpg',
                'https://wx3.sinaimg.cn/mw690/008vzrKlgy1hkqu4d6c9cj30hs138gog.jpg',
                'https://wx4.sinaimg.cn/mw690/008vzrKlgy1hkqu4kek0cj30hs0uyq5m.jpg',
                'https://wx2.sinaimg.cn/mw690/008vzrKlgy1hkqu4q063lj30hs0wz76c.jpg'],
    buildingInformation: "一种常见由感染引起的疾病",
    buildingPic: $r("app.media.case_thumbnail_a"),
    backgroundColor: $r('app.color.white'),
    starLinePic: [$r("app.media.starline")]
  },
  {
    id: 4,
    title: '中暑',
    subTitle: '一种高温环境引起体内温度调节功能障碍而导致的症状群',
    thumbnail: 'https://wx4.sinaimg.cn/mw690/008vzrKlgy1hki5husirgj30u00u0426.jpg',
    swiperPic: 'https://wx2.sinaimg.cn/mw690/008vzrKlgy1hkqugpx7zrj30r80i5js9.jpg',
    content: ['中暑是由于高温环境引起体内温度调节功能障碍而导致的症状群，其主要表现为体温升高、头晕、乏力、恶心、呕吐、皮肤潮红和可能的意识障碍。中暑可分为热衰竭和热射病两种类型。以下是一些预防中暑的措施：\n充足水分： 大量饮水有助于维持体温和防止脱水。尤其是在高温天气和进行剧烈运动时，要增加水分摄入。\n避免高温时段活动： 尽量避免在炎热的中午时段进行户外活动。选择在清晨或傍晚时段进行户外活动，避免长时间暴露在高温环境中。\n适当穿着： 穿着宽松、透气的衣物有助于散热。戴宽边帽和墨镜，以减少阳光直射。\n休息和阴凉： 在高温天气中，定期休息并找阴凉地方休息，有助于降低体温。\n适应期： 适应期是指在高温环境中逐渐适应，避免突然暴露于极端温度下。新来的人群应该给予更多的适应时间。',
              '治疗中暑的急救措施有：\n立即转移到阴凉处： 将患者移到阴凉的地方，避免阳光直射。\n饮水和补充电解质： 给患者提供大量清凉的水，并逐渐饮用含有盐分和糖分的电解质溶液。\n降温： 使用冷湿毛巾擦拭患者的身体，或者用冷水冲洗患者的身体，有助于散热。\n注意呼吸和心跳： 如果患者失去意识、呼吸急促或心跳不规则，需要立即寻求医疗帮助。\n就医： 对于热射病等严重中暑情况，需要紧急就医。医生可能会采取更进一步的措施，如静脉输液和其他治疗手段。'],
    subPicTop: $r('app.media.case_subpictop_a'),
    subPicBottom: $r('app.media.case_subpictop_a'),
    titleIcon: $r('app.media.titleIcon'),
    imageList: ['https://wx2.sinaimg.cn/mw690/008vzrKlgy1hkqtet1qvfj30rs19xgsa.jpg',
                'https://wx2.sinaimg.cn/mw690/008vzrKlgy1hkqtenzzajj30dw0op0vn.jpg',
                'https://wx2.sinaimg.cn/mw690/008vzrKlgy1hkqtejmmcej30hs0np77z.jpg',
                'https://wx2.sinaimg.cn/mw690/008vzrKlgy1hkqtejmmcej30hs0np77z.jpg'],
    buildingInformation: '一种高温环境引起体内温度调节功能障碍而导致的症状群',
    buildingPic: $r("app.media.case_thumbnail_a"),
    backgroundColor: $r('app.color.white'),
    starLinePic: [$r("app.media.starline")]
  },
]