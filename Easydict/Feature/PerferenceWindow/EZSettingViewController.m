//
//  EZGeneralViewController.m
//  Easydict
//
//  Created by tisfeng on 2022/12/15.
//  Copyright © 2022 izual. All rights reserved.
//

#import "EZSettingViewController.h"
#import "EZShortcut.h"
#import "EZConfiguration.h"
#import "EZWindowManager.h"

@interface EZSettingViewController () <NSComboBoxDelegate>

@property (nonatomic, strong) NSTextField *selectLabel;
@property (nonatomic, strong) NSTextField *inputLabel;
@property (nonatomic, strong) NSTextField *snipLabel;
@property (nonatomic, strong) NSTextField *showMiniLabel;

@property (nonatomic, strong) MASShortcutView *selectionShortcutView;
@property (nonatomic, strong) MASShortcutView *snipShortcutView;
@property (nonatomic, strong) MASShortcutView *inputShortcutView;
@property (nonatomic, strong) MASShortcutView *showMiniShortcutView;

@property (nonatomic, strong) NSView *separatorView;

@property (nonatomic, strong) NSTextField *showQueryIconLabel;
@property (nonatomic, strong) NSButton *showQueryIconButton;

@property (nonatomic, strong) NSTextField *fixedWindowPositionLabel;
@property (nonatomic, strong) NSComboBox *fixedWindowPositionComboBox;

@property (nonatomic, strong) NSTextField *playAudioLabel;
@property (nonatomic, strong) NSButton *autoPlayAudioButton;

@property (nonatomic, strong) NSTextField *snipTranslateLabel;
@property (nonatomic, strong) NSButton *snipTranslateButton;

@property (nonatomic, strong) NSTextField *autoCopyTextLabel;
@property (nonatomic, strong) NSButton *autoCopySelectedTextButton;
@property (nonatomic, strong) NSButton *autoCopyOCRTextButton;

@property (nonatomic, strong) NSTextField *languageDetectLabel;
@property (nonatomic, strong) NSButton *usesLanguageCorrectionButton;

@property (nonatomic, strong) NSTextField *showQuickLinkLabel;
@property (nonatomic, strong) NSButton *showGoogleQuickLinkButton;
@property (nonatomic, strong) NSButton *showEudicQuickLinkButton;

@property (nonatomic, strong) NSView *separatorView2;

@property (nonatomic, strong) NSTextField *hideMainWindowLabel;
@property (nonatomic, strong) NSButton *hideMainWindowButton;

@property (nonatomic, strong) NSTextField *launchLabel;
@property (nonatomic, strong) NSButton *launchAtStartupButton;

@property (nonatomic, strong) NSTextField *menuBarIconLabel;
@property (nonatomic, strong) NSButton *hideMenuBarIconButton;

@end


@implementation EZSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    [self setupUI];

    self.leftMargin = 120;
    [self updateViewSize];
}

- (void)setupUI {
    NSFont *font = [NSFont systemFontOfSize:13];

    NSTextField *selectLabel = [NSTextField labelWithString:NSLocalizedString(@"select_translate", nil)];
    selectLabel.font = font;
    [self.contentView addSubview:selectLabel];
    self.selectLabel = selectLabel;
    self.selectionShortcutView = [[MASShortcutView alloc] init];
    [self.contentView addSubview:self.selectionShortcutView];

    NSTextField *inputLabel = [NSTextField labelWithString:NSLocalizedString(@"input_translate", nil)];
    inputLabel.font = font;
    [self.contentView addSubview:inputLabel];
    self.inputLabel = inputLabel;
    self.inputShortcutView = [[MASShortcutView alloc] init];
    [self.contentView addSubview:self.inputShortcutView];

    NSTextField *snipLabel = [NSTextField labelWithString:NSLocalizedString(@"snip_translate", nil)];
    snipLabel.font = font;
    [self.contentView addSubview:snipLabel];
    self.snipLabel = snipLabel;
    self.snipShortcutView = [[MASShortcutView alloc] init];
    [self.contentView addSubview:self.snipShortcutView];

    NSTextField *showMiniLabel = [NSTextField labelWithString:NSLocalizedString(@"show_mini_window", nil)];
    showMiniLabel.font = font;
    [self.contentView addSubview:showMiniLabel];
    self.showMiniLabel = showMiniLabel;
    self.showMiniShortcutView = [[MASShortcutView alloc] init];
    [self.contentView addSubview:self.showMiniShortcutView];

    if ([EZLanguageManager isEnglishFirstLanguage]) {
        self.leftmostView = self.showMiniLabel;
    }

    [self.selectionShortcutView setAssociatedUserDefaultsKey:EZSelectionShortcutKey];
    [self.inputShortcutView setAssociatedUserDefaultsKey:EZInputShortcutKey];
    [self.snipShortcutView setAssociatedUserDefaultsKey:EZSnipShortcutKey];
    [self.showMiniShortcutView setAssociatedUserDefaultsKey:EZShowMiniShortcutKey];

    NSColor *separatorLightColor = [NSColor mm_colorWithHexString:@"#D9DADA"];
    NSColor *separatorDarkColor = [NSColor mm_colorWithHexString:@"#3C3C3C"];

    NSView *separatorView = [[NSView alloc] init];
    [self.contentView addSubview:separatorView];
    self.separatorView = separatorView;
    separatorView.wantsLayer = YES;
    [separatorView excuteLight:^(NSView *view) {
        view.layer.backgroundColor = separatorLightColor.CGColor;
    } drak:^(NSView *view) {
        view.layer.backgroundColor = separatorDarkColor.CGColor;
    }];

    NSTextField *showQueryIconLabel = [NSTextField labelWithString:NSLocalizedString(@"show_icon", nil)];
    showQueryIconLabel.font = font;
    [self.contentView addSubview:showQueryIconLabel];
    self.showQueryIconLabel = showQueryIconLabel;

    NSString *showQueryIconTitle = NSLocalizedString(@"auto_show_icon", nil);
    self.showQueryIconButton = [NSButton checkboxWithTitle:showQueryIconTitle target:self action:@selector(autoSelectTextButtonClicked:)];
    [self.contentView addSubview:self.showQueryIconButton];

    if ([EZLanguageManager isEnglishFirstLanguage]) {
        self.rightmostView = self.showQueryIconButton;
    }

    NSTextField *fixedWindowPositionLabel = [NSTextField labelWithString:NSLocalizedString(@"fixed_window_position", nil)];
    fixedWindowPositionLabel.font = font;
    [self.contentView addSubview:fixedWindowPositionLabel];
    self.fixedWindowPositionLabel = fixedWindowPositionLabel;

    self.fixedWindowPositionComboBox = [[NSComboBox alloc] init];
    self.fixedWindowPositionComboBox.editable = NO;
    MMOrderedDictionary *fixedWindowPostionDict = [EZLayoutManager.shared fixedWindowPositionDict];
    NSArray *fixedWindowPositionItems = [fixedWindowPostionDict sortedValues];
    [self.fixedWindowPositionComboBox addItemsWithObjectValues:fixedWindowPositionItems];
    [self.contentView addSubview:self.fixedWindowPositionComboBox];
    self.fixedWindowPositionComboBox.delegate = self;


    NSTextField *playAudioLabel = [NSTextField labelWithString:NSLocalizedString(@"play_audio", nil)];
    playAudioLabel.font = font;
    [self.contentView addSubview:playAudioLabel];
    self.playAudioLabel = playAudioLabel;

    NSString *autoPlayAudioTitle = NSLocalizedString(@"auto_play_audio", nil);
    self.autoPlayAudioButton = [NSButton checkboxWithTitle:autoPlayAudioTitle target:self action:@selector(autoPlayAudioButtonClicked:)];
    [self.contentView addSubview:self.autoPlayAudioButton];


    NSTextField *snipTranslateLabel = [NSTextField labelWithString:NSLocalizedString(@"snip_translate", nil)];
    snipTranslateLabel.font = font;
    [self.contentView addSubview:snipTranslateLabel];
    self.snipTranslateLabel = snipTranslateLabel;

    NSString *snipTranslateTitle = NSLocalizedString(@"auto_snip_translate", nil);
    self.snipTranslateButton = [NSButton checkboxWithTitle:snipTranslateTitle target:self action:@selector(snipTranslateButtonClicked:)];
    [self.contentView addSubview:self.snipTranslateButton];

    NSTextField *autoCopyTextLabel = [NSTextField labelWithString:NSLocalizedString(@"auto_copy_text", nil)];
    autoCopyTextLabel.font = font;
    [self.contentView addSubview:autoCopyTextLabel];
    self.autoCopyTextLabel = autoCopyTextLabel;

    NSString *autoCopySelectedText = NSLocalizedString(@"auto_copy_selected_text", nil);
    self.autoCopySelectedTextButton = [NSButton checkboxWithTitle:autoCopySelectedText target:self action:@selector(autoCopySelectedTextButtonClicked:)];
    [self.contentView addSubview:self.autoCopySelectedTextButton];

    NSString *autoCopyOCRText = NSLocalizedString(@"auto_copy_ocr_text", nil);
    self.autoCopyOCRTextButton = [NSButton checkboxWithTitle:autoCopyOCRText target:self action:@selector(autoCopyOCRTextButtonClicked:)];
    [self.contentView addSubview:self.autoCopyOCRTextButton];

    NSTextField *usesLanguageCorrectionLabel = [NSTextField labelWithString:NSLocalizedString(@"language_detect", nil)];
    usesLanguageCorrectionLabel.font = font;
    [self.contentView addSubview:usesLanguageCorrectionLabel];
    self.languageDetectLabel = usesLanguageCorrectionLabel;

    NSString *usesLanguageCorrection = NSLocalizedString(@"use_language_detect_correction", nil);
    self.usesLanguageCorrectionButton = [NSButton checkboxWithTitle:usesLanguageCorrection target:self action:@selector(usesLanguageCorrectionButtonClicked:)];
    [self.contentView addSubview:self.usesLanguageCorrectionButton];
    self.usesLanguageCorrectionButton.toolTip = @"If this option is enabled, when the system language recognition text is a non-preferred language, the API recognition will be called.";

    NSTextField *showQuickLinkLabel = [NSTextField labelWithString:NSLocalizedString(@"quick_link", nil)];
    showQuickLinkLabel.font = font;
    [self.contentView addSubview:showQuickLinkLabel];
    self.showQuickLinkLabel = showQuickLinkLabel;

    NSString *showGoogleQuickLink = NSLocalizedString(@"show_google_quick_link", nil);
    self.showGoogleQuickLinkButton = [NSButton checkboxWithTitle:showGoogleQuickLink target:self action:@selector(showGoogleQuickLinkButtonClicked:)];
    [self.contentView addSubview:self.showGoogleQuickLinkButton];

    NSString *showEudicQuickLink = NSLocalizedString(@"show_eudic_quick_link", nil);
    self.showEudicQuickLinkButton = [NSButton checkboxWithTitle:showEudicQuickLink target:self action:@selector(showEudicQuickLinkButtonClicked:)];
    [self.contentView addSubview:self.showEudicQuickLinkButton];


    NSView *separatorView2 = [[NSView alloc] init];
    [self.contentView addSubview:separatorView2];
    self.separatorView2 = separatorView2;
    separatorView2.wantsLayer = YES;
    [separatorView2 excuteLight:^(NSView *view) {
        view.layer.backgroundColor = separatorLightColor.CGColor;
    } drak:^(NSView *view) {
        view.layer.backgroundColor = separatorDarkColor.CGColor;
    }];

    NSTextField *hideMainWindowLabel = [NSTextField labelWithString:NSLocalizedString(@"show_main_window", nil)];
    hideMainWindowLabel.font = font;
    [self.contentView addSubview:hideMainWindowLabel];
    self.hideMainWindowLabel = hideMainWindowLabel;

    NSString *hideMainWindowTitle = NSLocalizedString(@"hide_main_window", nil);
    self.hideMainWindowButton = [NSButton checkboxWithTitle:hideMainWindowTitle target:self action:@selector(hideMainWindowButtonClicked:)];
    [self.contentView addSubview:self.hideMainWindowButton];

    NSTextField *launchLabel = [NSTextField labelWithString:NSLocalizedString(@"launch", nil)];
    launchLabel.font = font;
    [self.contentView addSubview:launchLabel];
    self.launchLabel = launchLabel;

    NSString *launchAtStartupTitle = NSLocalizedString(@"launch_at_startup", nil);
    self.launchAtStartupButton = [NSButton checkboxWithTitle:launchAtStartupTitle target:self action:@selector(launchAtStartupButtonClicked:)];
    [self.contentView addSubview:self.launchAtStartupButton];

    NSTextField *menubarIconLabel = [NSTextField labelWithString:NSLocalizedString(@"menu_bar_icon", nil)];
    menubarIconLabel.font = font;
    [self.contentView addSubview:menubarIconLabel];
    self.menuBarIconLabel = menubarIconLabel;

    NSString *hideMenuBarIcon = NSLocalizedString(@"hide_menu_bar_icon", nil);
    self.hideMenuBarIconButton = [NSButton checkboxWithTitle:hideMenuBarIcon target:self action:@selector(hideMenuBarIconButtonClicked:)];
    [self.contentView addSubview:self.hideMenuBarIconButton];


    EZConfiguration *configuration = [EZConfiguration shared];
    self.showQueryIconButton.mm_isOn = configuration.autoSelectText;
    self.autoPlayAudioButton.mm_isOn = configuration.autoPlayAudio;
    self.launchAtStartupButton.mm_isOn = configuration.launchAtStartup;
    self.hideMainWindowButton.mm_isOn = configuration.hideMainWindow;
    self.snipTranslateButton.mm_isOn = configuration.autoSnipTranslate;
    self.autoCopySelectedTextButton.mm_isOn = configuration.autoCopySelectedText;
    self.autoCopyOCRTextButton.mm_isOn = configuration.autoCopyOCRText;
    self.usesLanguageCorrectionButton.mm_isOn = configuration.languageDetectCorrection;
    self.showGoogleQuickLinkButton.mm_isOn = configuration.showGoogleQuickLink;
    self.showEudicQuickLinkButton.mm_isOn = configuration.showEudicQuickLink;
    self.hideMenuBarIconButton.mm_isOn = configuration.hideMenuBarIcon;

    NSString *fixedWindowPosition = [fixedWindowPostionDict objectForKey:@(configuration.fixedWindowPosition)];
    self.fixedWindowPositionComboBox.stringValue = fixedWindowPosition;
}

- (void)updateViewConstraints {
    CGFloat separatorMargin = 40;

    [self.selectLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.leftMargin).priorityLow();
        make.top.equalTo(self.contentView).offset(self.topMargin).priorityLow();
    }];
    self.topmostView = self.selectLabel;

    [self.selectionShortcutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectLabel.mas_right).offset(self.horizontalPadding);
        make.centerY.equalTo(self.selectLabel);
        make.height.mas_equalTo(25);
    }];

    [self.inputLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.selectLabel);
        make.top.equalTo(self.selectionShortcutView.mas_bottom).offset(self.verticalPadding);
    }];
    [self.inputShortcutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputLabel.mas_right).offset(self.horizontalPadding);
        make.centerY.equalTo(self.inputLabel);
        make.height.equalTo(self.selectionShortcutView);
    }];

    [self.snipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.selectLabel);
        make.top.equalTo(self.inputShortcutView.mas_bottom).offset(self.verticalPadding);
    }];
    [self.snipShortcutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.snipLabel.mas_right).offset(self.horizontalPadding);
        make.centerY.equalTo(self.snipLabel);
        make.height.equalTo(self.selectionShortcutView);
    }];

    [self.showMiniLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.selectLabel);
        make.top.equalTo(self.snipShortcutView.mas_bottom).offset(self.verticalPadding);
    }];


    [self.showMiniShortcutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showMiniLabel.mas_right).offset(self.horizontalPadding);
        make.centerY.equalTo(self.showMiniLabel);
        make.height.equalTo(self.selectionShortcutView);
    }];

    [self.separatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.inset(separatorMargin);
        make.top.equalTo(self.showMiniLabel.mas_bottom).offset(1.5 * self.verticalPadding);
        make.height.mas_equalTo(1);
    }];

    [self.showQueryIconLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.selectLabel);
        make.top.equalTo(self.separatorView.mas_bottom).offset(1.5 * self.verticalPadding);
    }];

    if ([EZLanguageManager isChineseFirstLanguage]) {
        self.leftmostView = self.showQueryIconLabel;
    }

    [self.showQueryIconButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showQueryIconLabel.mas_right).offset(self.horizontalPadding);
        make.centerY.equalTo(self.showQueryIconLabel);
    }];

    if ([EZLanguageManager isChineseFirstLanguage]) {
        self.rightmostView = self.showQueryIconButton;
    }

    if ([EZLanguageManager isEnglishFirstLanguage]) {
        self.rightmostView = self.showQueryIconButton;
    }

    [self.fixedWindowPositionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.showQueryIconLabel);
        make.top.equalTo(self.showQueryIconButton.mas_bottom).offset(self.verticalPadding);
    }];

    [self.fixedWindowPositionComboBox mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fixedWindowPositionLabel.mas_right).offset(self.horizontalPadding);
        make.centerY.equalTo(self.fixedWindowPositionLabel);
        make.size.mas_equalTo(CGSizeMake(120, 25));
    }];

    [self.playAudioLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.showQueryIconLabel);
        make.top.equalTo(self.fixedWindowPositionComboBox.mas_bottom).offset(self.verticalPadding);
    }];

    [self.autoPlayAudioButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playAudioLabel.mas_right).offset(self.horizontalPadding);
        make.centerY.equalTo(self.playAudioLabel);
    }];

    [self.snipTranslateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.showQueryIconLabel);
        make.top.equalTo(self.autoPlayAudioButton.mas_bottom).offset(self.verticalPadding);
    }];

    [self.snipTranslateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.snipTranslateLabel.mas_right).offset(self.horizontalPadding);
        make.centerY.equalTo(self.snipTranslateLabel);
    }];

    [self.autoCopyTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.showQueryIconLabel);
        make.top.equalTo(self.snipTranslateButton.mas_bottom).offset(self.verticalPadding);
    }];

    [self.autoCopySelectedTextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.autoCopyTextLabel.mas_right).offset(self.horizontalPadding);
        make.centerY.equalTo(self.autoCopyTextLabel);
    }];

    [self.autoCopyOCRTextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.autoCopySelectedTextButton);
        make.top.equalTo(self.autoCopySelectedTextButton.mas_bottom).offset(self.verticalPadding);
    }];

    [self.languageDetectLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.showQueryIconLabel);
        make.top.equalTo(self.autoCopyOCRTextButton.mas_bottom).offset(self.verticalPadding);
    }];

    [self.usesLanguageCorrectionButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.languageDetectLabel.mas_right).offset(self.horizontalPadding);
        make.centerY.equalTo(self.languageDetectLabel);
    }];

    [self.showQuickLinkLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.showQueryIconLabel);
        make.top.equalTo(self.usesLanguageCorrectionButton.mas_bottom).offset(self.verticalPadding);
    }];

    [self.showGoogleQuickLinkButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showQuickLinkLabel.mas_right).offset(self.horizontalPadding);
        make.centerY.equalTo(self.showQuickLinkLabel);
    }];

    [self.showEudicQuickLinkButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.showGoogleQuickLinkButton);
        make.top.equalTo(self.showGoogleQuickLinkButton.mas_bottom).offset(self.verticalPadding);
    }];


    [self.separatorView2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.separatorView);
        make.top.equalTo(self.showEudicQuickLinkButton.mas_bottom).offset(1.5 * self.verticalPadding);
        make.height.equalTo(self.separatorView);
    }];

    [self.hideMainWindowLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.showQueryIconLabel);
        make.top.equalTo(self.separatorView2.mas_bottom).offset(1.5 * self.verticalPadding);
    }];

    [self.hideMainWindowButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hideMainWindowLabel.mas_right).offset(self.horizontalPadding);
        make.centerY.equalTo(self.hideMainWindowLabel);
    }];

    [self.launchLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.showQueryIconLabel);
        make.top.equalTo(self.hideMainWindowButton.mas_bottom).offset(self.verticalPadding);
    }];

    [self.launchAtStartupButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.launchLabel.mas_right).offset(self.horizontalPadding);
        make.centerY.equalTo(self.launchLabel);
    }];

    [self.menuBarIconLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.showQueryIconLabel);
        make.top.equalTo(self.launchAtStartupButton.mas_bottom).offset(self.verticalPadding);
    }];

    [self.hideMenuBarIconButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.menuBarIconLabel.mas_right).offset(self.horizontalPadding);
        make.centerY.equalTo(self.menuBarIconLabel);
    }];


    self.bottommostView = self.hideMenuBarIconButton;

    [super updateViewConstraints];
}

#pragma mark - event

- (void)autoSelectTextButtonClicked:(NSButton *)sender {
    EZConfiguration.shared.autoSelectText = sender.mm_isOn;

    if (sender.mm_isOn) {
        [self checkAppIsTrusted];
    }
}

- (BOOL)checkAppIsTrusted {
    BOOL isTrusted = AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef) @{(__bridge NSString *)kAXTrustedCheckOptionPrompt : @YES});
    NSLog(@"isTrusted: %d", isTrusted);

    return isTrusted == YES;
}

- (void)launchAtStartupButtonClicked:(NSButton *)sender {
    EZConfiguration.shared.launchAtStartup = sender.mm_isOn;
}

- (void)hideMainWindowButtonClicked:(NSButton *)sender {
    EZConfiguration.shared.hideMainWindow = sender.mm_isOn;

    [[EZWindowManager shared] showOrHideDockAppAndMainWindow];
}

- (void)snipTranslateButtonClicked:(NSButton *)sender {
    EZConfiguration.shared.autoSnipTranslate = sender.mm_isOn;
}

- (void)autoPlayAudioButtonClicked:(NSButton *)sender {
    EZConfiguration.shared.autoPlayAudio = sender.mm_isOn;
}

- (void)autoCopySelectedTextButtonClicked:(NSButton *)sender {
    EZConfiguration.shared.autoCopySelectedText = sender.mm_isOn;
}

- (void)autoCopyOCRTextButtonClicked:(NSButton *)sender {
    EZConfiguration.shared.autoCopyOCRText = sender.mm_isOn;
}

- (void)usesLanguageCorrectionButtonClicked:(NSButton *)sender {
    EZConfiguration.shared.languageDetectCorrection = sender.mm_isOn;
}

- (void)showGoogleQuickLinkButtonClicked:(NSButton *)sender {
    EZConfiguration.shared.showGoogleQuickLink = sender.mm_isOn;
}

- (void)showEudicQuickLinkButtonClicked:(NSButton *)sender {
    EZConfiguration.shared.showEudicQuickLink = sender.mm_isOn;
}

- (void)hideMenuBarIconButtonClicked:(NSButton *)sender {
    EZConfiguration.shared.hideMenuBarIcon = sender.mm_isOn;
}

#pragma mark - NSComboBoxDelegate

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    NSComboBox *comboBox = notification.object;
    NSInteger selectedIndex = comboBox.indexOfSelectedItem;
    
    MMOrderedDictionary *dict = [EZLayoutManager.shared fixedWindowPositionDict];
    EZConfiguration.shared.fixedWindowPosition = [[dict keyAtIndex:selectedIndex] integerValue];
}

#pragma mark - MASPreferencesViewController

- (NSString *)viewIdentifier {
    return self.className;
}

- (NSString *)toolbarItemLabel {
    return NSLocalizedString(@"setting", nil);
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:@"toolbar_setting"];
}

- (BOOL)hasResizableWidth {
    return NO;
}

- (BOOL)hasResizableHeight {
    return NO;
}

@end
