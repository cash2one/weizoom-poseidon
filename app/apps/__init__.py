# -*- coding: utf-8 -*-
__author__ = 'robert'


import os

from django.conf import settings

FIRST_NAV = 'promotion'

#
# 应用和营销左侧垂直方向三级导航信息
#
MALL_PROMOTION_PROMOTIONS_NAV = 'promotionQuery'
MALL_PROMOTION_FLASH_SALE_NAV = 'flashSale'
MALL_PROMOTION_PREMIUM_SALE_NAV = 'buyGifts'
MALL_PROMOTION_PRICE_CUT_NAV = 'fullReduction'
MALL_PROMOTION_COUPON_NAV = 'Coupon'
MALL_PROMOTION_INTEGRAL_SALE_NAV = 'integralYingyon'
MALL_PROMOTION_ISSUING_COUPONS_NAV = 'issuingCoupon'
MALL_PROMOTION_FORBIDDEN_COUPON_PRODUCT_NAV = 'forbiddenCouponProduct'

MALL_APPS_LOTTERY_NAV = 'lotteries'
MALL_APPS_FEEDBACK_NAV = 'exsurveies'
MALL_APPS_SURVEY_NAV = 'surveies'
MALL_APPS_EVENT_NAV = 'events'
MALL_APPS_VOTE_NAV = 'votes'
MALL_APPS_SIGN_NAV = 'sign'
MALL_APPS_RED_ENVELOPE_NAV = 'red_envelopes'
MALL_APPS_POWERME_NAV = 'powermes'
MALL_APPS_REDPACKET_NAV = 'red_packet'

#
# 应用和营销左侧垂直方向二级导航信息
#
MALL_PROMOTION_SECOND_NAV = MALL_PROMOTION_FLASH_SALE_NAV
MALL_APPS_SECOND_NAV = MALL_APPS_LOTTERY_NAV
SECOND_NAV = MALL_APPS_SECOND_NAV


MALL_PROMOTION_AND_APPS_SECOND_NAV = {
    'section': u'',
    'navs': [
        # 商品管理
        {
            'name': MALL_PROMOTION_SECOND_NAV,
            'title': u'促销管理',
            'url': '/mall2/flash_sale_list/',
            'permission': 'manage_promotion',
            'third_navs': [
                # 商品管理
                # {
                #     'name': MALL_PROMOTION_PROMOTIONS_NAV,
                #     'title': u'促销查询',
                #     'url': '/mall2/promotion_list/',
                #     'permission': ['search_promotion', ]
                # },
                {
                    'name': MALL_PROMOTION_FLASH_SALE_NAV,
                    'title': u'限时抢购',
                    'url': '/mall2/flash_sale_list/',
                    'permission': 'manage_flash_sale'
                },
                {
                    'name': MALL_PROMOTION_PREMIUM_SALE_NAV,
                    'title': u'买赠',
                    'url': '/mall2/premium_sale_list/',
                    'permission': 'manage_premium_sale'
                },
                # {
                #     'name': MALL_PROMOTION_PRICE_CUT_NAV,
                #     'title': u'满减',
                #     'url': '/mall2/price_cut_list/',
                #     'permission': ['manage_price_cut', ]
                # },
                {
                    'name': MALL_PROMOTION_INTEGRAL_SALE_NAV,
                    'title': u'积分应用',
                    'url': '/mall2/integral_sales_list/',
                    'permission': 'manage_integral_sale'
                },
                {
                    'name': MALL_PROMOTION_COUPON_NAV,
                    'title': u'优惠券',
                    'url': '/mall2/coupon_rule_list/',
                    'permission': 'manage_coupon'
                },
                {
                    'name': MALL_PROMOTION_ISSUING_COUPONS_NAV,
                    'title': u'发优惠券',
                    'url': '/mall2/issuing_coupons_record_list/',
                    'permission': 'manage_send_coupon'
                },
                # {
                #     'name': MALL_PROMOTION_ORDER_RED_ENVELOPE,
                #     'title': u'分享红包',
                #     'url': '/mall2/red_envelope_rule_list/',
                #     'permission': ['manage_order_red_envelope', ]
                # }
                {
                    'name': MALL_PROMOTION_FORBIDDEN_COUPON_PRODUCT_NAV,
                    'title': u'禁用优惠券商品',
                    'url': '/mall2/forbidden_coupon_product/',
                    'permission': 'forbidden_coupon_product'
                }
            ]
        },
        {
            'name': MALL_APPS_SECOND_NAV,
            'title': u'百宝箱',
            'url': '/apps/lottery/lotteries/',
            'permission': 'manage_apps',
            'third_navs': [
                {
                    'name': MALL_APPS_LOTTERY_NAV,
                    'title': "微信抽奖",
                    'url': '/apps/lottery/lotteries/',
                    'permission': ''
                },
                # {
                    # 'name': MALL_APPS_FEEDBACK_NAV,
                    # 'title': "用户反馈",
                    # 'url': '/apps/feedback/feedbacks/',
                    # 'permission': []
                # },
                 {
                    'name': MALL_APPS_SURVEY_NAV,
                    'title': "用户调研",
                    'url': '/apps/survey/surveies/',
                    'permission': ''
                },
                {
                    'name': MALL_APPS_EVENT_NAV,
                    'title': "活动报名",
                    'url': '/apps/event/events/',
                    'permission': []
                },
                {
                    'name': MALL_APPS_VOTE_NAV,
                    'title': "微信投票",
                    'url': '/apps/vote/votes/',
                    'permission': ''
                },
                {
                    'name': MALL_APPS_RED_ENVELOPE_NAV,
                    'title': u'分享红包',
                    'url': '/apps/red_envelope/red_envelope_rule_list/',
                    'permission': ''
                },
                {
                    'name': MALL_APPS_SIGN_NAV,
                    'title': u'签到',
                    'url': '/apps/sign/sign/',
                    'permission': ''
                },
                {
                    'name': MALL_APPS_POWERME_NAV,
                    'title': u'微助力',
                    'url': '/apps/powerme/powermes/',
                    'permission': ''
                },
                {
                    'name': MALL_APPS_FEEDBACK_NAV,
                    'title': u'用户反馈',
                    'url': '/apps/exsurvey/exsurveies/',
                    'permission': '',
                    'users': ['njtest','ceshi01', 'wzjx001', 'weizoomxs', 'weizoommm', 'weshop', 'weizoomclub', 'weizoomshop'] #这些帐号可以显示用户反馈
                },
                # {
                #     'name': MALL_APPS_REDPACKET_NAV,
                #     'title': u'拼红包',
                #     'url': '/apps/red_packet/red_packets/',
                #     'permission': ''
                # }
            ]
        }
    ]

}

########################################################################
# get_promotion_and_apps_second_navs: 获得应用和营销的二级导航
########################################################################
def get_promotion_and_apps_second_navs(request):
    second_navs = [MALL_PROMOTION_AND_APPS_SECOND_NAV]

    return second_navs