
#import "GameVC.h"
#import "Tool.h"
#import "CCTapped.h"
#import "DetailVC.h"
#import <AVFoundation/AVFoundation.h>
#import "SDKSwitch.h"
#import "SDKShowViewController.h"
static NSInteger coinW = 20;
static NSInteger coinH = 10;
static NSInteger cardT = 1.5;
@interface GameVC (){
    NSDictionary *_pokerDic;
    NSArray *_pokersArr;
    BOOL _isPlaymusic;
    NSInteger coinX;
    NSInteger coinY;
    NSMutableArray *ansArr;
    NSMutableArray *allCoinArr;
    NSMutableArray *cardArr;
    NSInteger chooseCoin;
}
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UIImageView *playerimg;
@property (weak, nonatomic) IBOutlet UIImageView *bankerImg;
@property (weak, nonatomic) IBOutlet UIImageView *tieimg;
@property (weak, nonatomic) IBOutlet UIImageView *glod_50Img;
@property (weak, nonatomic) IBOutlet UIImageView *glod_100Img;
@property (weak, nonatomic) IBOutlet UIImageView *gold_500Img;
@property (weak, nonatomic) IBOutlet UIImageView *gold_1000Img;
@property (nonatomic)UIImageView *resultBackgroundImg;
@property (nonatomic)UILabel *resultLabel;
@property (nonatomic)UILabel *resultWinLabel;

@property (weak, nonatomic) IBOutlet UIImageView *playerCardimg1;
@property (weak, nonatomic) IBOutlet UIImageView *playerCardimg2;
@property (weak, nonatomic) IBOutlet UIImageView *playerCardimg3;
@property (weak, nonatomic) IBOutlet UIImageView *bankerCardimg1;
@property (weak, nonatomic) IBOutlet UIImageView *bankerCardimg2;
@property (weak, nonatomic) IBOutlet UIImageView *bankerCardimg3;
@property (weak, nonatomic) IBOutlet UILabel *playerAnsLab;
@property (weak, nonatomic) IBOutlet UILabel *bankerAnsLab;
@property (weak, nonatomic) IBOutlet UILabel *playerTotalLab;
@property (weak, nonatomic) IBOutlet UILabel *bankerTotalLab;
@property (weak, nonatomic) IBOutlet UILabel *tieTotalLab;

@property (nonatomic)NSInteger isPoBoT;//!<闲家1 庄家2 和局3
@property (strong, nonatomic) AVAudioPlayer *player;

@property (nonatomic, assign) BOOL isPlaymusic;

@end

@implementation GameVC

- (void)creatMp3:(NSString *)str{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:str ofType:@"mp3"];
    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    NSError *playerError;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:&playerError];
    if (_player == NULL)
    {
        NSLog(@"fail to play audio :(");
        return;
    }
    //循环次数
    [_player setNumberOfLoops:-1];
    
    //播放声音
    [_player setVolume:0.1];
    
    //预备播放
    [_player prepareToPlay];
    
    //播放
    [_player play];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //开启SDK
    [self lauchSDK];
    _isPlaymusic = YES;
    allCoinArr = [@[]mutableCopy];
    cardArr = [@[]mutableCopy];
    [self creatMp3:@"背景音乐"];
    _pokerDic = @{@"1_1":@"1",@"2_1":@"2",@"3_1":@"3",@"4_1":@"4",@"5_1":@"5",@"6_1":@"6",@"7_1":@"7",@"8_1":@"8",@"9_1":@"9",@"10_1":@"0",@"11_1":@"0",@"12_1":@"0",@"13_1":@"0",
                  @"1_2":@"1",@"2_2":@"2",@"3_2":@"3",@"4_2":@"4",@"5_2":@"5",@"6_2":@"6",@"7_2":@"7",@"8_2":@"8",@"9_2":@"9",@"10_2":@"0",@"11_2":@"0",@"12_2":@"0",@"13_2":@"0",
                  @"1_3":@"1",@"2_3":@"2",@"3_3":@"3",@"4_3":@"4",@"5_3":@"5",@"6_3":@"6",@"7_3":@"7",@"8_3":@"8",@"9_3":@"9",@"10_3":@"0",@"11_3":@"0",@"12_3":@"0",@"13_3":@"0",
                  @"1_4":@"1",@"2_4":@"2",@"3_4":@"3",@"4_4":@"4",@"5_4":@"5",@"6_4":@"6",@"7_4":@"7",@"8_4":@"8",@"9_4":@"9",@"10_4":@"0",@"11_4":@"0",@"12_4":@"0",@"13_4":@"0"};
    _pokersArr = [_pokerDic allKeys];
    
    chooseCoin = 50;
    _glod_50Img.layer.borderColor = [[UIColor whiteColor] CGColor];
    _glod_50Img.layer.borderWidth = 2;
    _glod_100Img.layer.borderColor = [[UIColor clearColor] CGColor];
    _glod_100Img.layer.borderWidth = 2;
    _gold_500Img.layer.borderColor = [[UIColor clearColor] CGColor];
    _gold_500Img.layer.borderWidth = 2;
    _gold_1000Img.layer.borderColor = [[UIColor clearColor] CGColor];
    _gold_1000Img.layer.borderWidth = 2;
    [_glod_50Img whenTapped:^{
        chooseCoin = 50;
        _glod_50Img.layer.borderColor = [[UIColor whiteColor] CGColor];
        _glod_100Img.layer.borderColor = [[UIColor clearColor] CGColor];
        _gold_500Img.layer.borderColor = [[UIColor clearColor] CGColor];
        _gold_1000Img.layer.borderColor = [[UIColor clearColor] CGColor];
    }];
    [_glod_100Img whenTapped:^{
        chooseCoin = 100;
        _glod_50Img.layer.borderColor = [[UIColor clearColor] CGColor];
        _glod_100Img.layer.borderColor = [[UIColor whiteColor] CGColor];
        _gold_500Img.layer.borderColor = [[UIColor clearColor] CGColor];
        _gold_1000Img.layer.borderColor = [[UIColor clearColor] CGColor];
    }];
    [_gold_500Img whenTapped:^{
        chooseCoin = 500;
        _glod_50Img.layer.borderColor = [[UIColor clearColor] CGColor];
        _glod_100Img.layer.borderColor = [[UIColor clearColor] CGColor];
        _gold_500Img.layer.borderColor = [[UIColor whiteColor] CGColor];
        _gold_1000Img.layer.borderColor = [[UIColor clearColor] CGColor];
    }];
    [_gold_1000Img whenTapped:^{
        chooseCoin = 1000;
        _glod_50Img.layer.borderColor = [[UIColor clearColor] CGColor];
        _glod_100Img.layer.borderColor = [[UIColor clearColor] CGColor];
        _gold_500Img.layer.borderColor = [[UIColor clearColor] CGColor];
        _gold_1000Img.layer.borderColor = [[UIColor whiteColor] CGColor];
    }];
    [_playerimg whenTapped:^{
        if (_isPlaymusic == YES) {
            [Tool play:@"下注"];
        }else{
            
        }
//        _bankerImg.userInteractionEnabled = NO;
//        _tieimg.userInteractionEnabled = NO;
        _isPoBoT = 1;
        if ([_totalLab.text integerValue] - chooseCoin < 0) {
            
        }else{
            if (chooseCoin == 50) {
                UIImageView *NewGoldImg = [[UIImageView alloc] initWithFrame:_glod_50Img.frame];
                NewGoldImg.image = [UIImage imageNamed:@"数字50"];
                [self.view addSubview:NewGoldImg];
                [allCoinArr addObject:NewGoldImg];
                [UIView animateWithDuration:0.5 animations:^{
                    NewGoldImg.frame = CGRectMake(coinX, coinY, coinW, coinH);
                }];
                _playerTotalLab.text = [NSString stringWithFormat:@"%ld",[_playerTotalLab.text integerValue] +chooseCoin];
                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] - chooseCoin];
            }else if (chooseCoin == 100) {
                UIImageView *NewGoldImg = [[UIImageView alloc] initWithFrame:_glod_100Img.frame];
                NewGoldImg.image = [UIImage imageNamed:@"数字100"];
                [self.view addSubview:NewGoldImg];
                [allCoinArr addObject:NewGoldImg];
                [UIView animateWithDuration:0.5 animations:^{
                    NewGoldImg.frame = CGRectMake(coinX, coinY, coinW, coinH);
                }];
                _playerTotalLab.text = [NSString stringWithFormat:@"%ld",[_playerTotalLab.text integerValue] +chooseCoin];
                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] - chooseCoin];
            }else if (chooseCoin == 500){
                UIImageView *NewGoldImg = [[UIImageView alloc] initWithFrame:_gold_500Img.frame];
                NewGoldImg.image = [UIImage imageNamed:@"数字500"];
                [self.view addSubview:NewGoldImg];
                [allCoinArr addObject:NewGoldImg];
                [UIView animateWithDuration:0.5 animations:^{
                    NewGoldImg.frame = CGRectMake(coinX, coinY, coinW, coinH);
                }];
                _playerTotalLab.text = [NSString stringWithFormat:@"%ld",[_playerTotalLab.text integerValue] +chooseCoin];
                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] - chooseCoin];
            }else if (chooseCoin == 1000){
                UIImageView *NewGoldImg = [[UIImageView alloc] initWithFrame:_gold_1000Img.frame];
                NewGoldImg.image = [UIImage imageNamed:@"数字1000"];
                [self.view addSubview:NewGoldImg];
                [allCoinArr addObject:NewGoldImg];
                [UIView animateWithDuration:0.5 animations:^{
                    NewGoldImg.frame = CGRectMake(coinX, coinY, coinW, coinH);
                }];
                _playerTotalLab.text = [NSString stringWithFormat:@"%ld",[_playerTotalLab.text integerValue] +chooseCoin];
                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] - chooseCoin];
            }
        }
    }];
    
    [_tieimg whenTapped:^{
        if (_isPlaymusic == YES) {
            [Tool play:@"下注"];
        }else{
            
        }
//        _bankerImg.userInteractionEnabled = NO;
//        _playerimg.userInteractionEnabled = NO;
        _isPoBoT = 3;
        if ([_totalLab.text integerValue] - chooseCoin <0) {
            
        }else{
            if (chooseCoin == 50) {
                UIImageView *NewGoldImg = [[UIImageView alloc] initWithFrame:_glod_50Img.frame];
                NewGoldImg.image = [UIImage imageNamed:@"数字50"];
                [self.view addSubview:NewGoldImg];
                [allCoinArr addObject:NewGoldImg];
                
                [UIView animateWithDuration:0.5 animations:^{
                    NewGoldImg.frame = CGRectMake(coinX, coinY, coinW, coinH);
                }];
                _tieTotalLab.text = [NSString stringWithFormat:@"%ld",[_tieTotalLab.text integerValue] +chooseCoin];
                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] - chooseCoin];
            }else if (chooseCoin == 100) {
                UIImageView *NewGoldImg = [[UIImageView alloc] initWithFrame:_glod_100Img.frame];
                NewGoldImg.image = [UIImage imageNamed:@"数字100"];
                [self.view addSubview:NewGoldImg];
                [allCoinArr addObject:NewGoldImg];
                
                [UIView animateWithDuration:0.5 animations:^{
                    NewGoldImg.frame = CGRectMake(coinX, coinY, coinW, coinH);
                }];
                _tieTotalLab.text = [NSString stringWithFormat:@"%ld",[_tieTotalLab.text integerValue] +chooseCoin];
                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] - chooseCoin];
            }else if (chooseCoin == 500){
                UIImageView *NewGoldImg = [[UIImageView alloc] initWithFrame:_gold_500Img.frame];
                NewGoldImg.image = [UIImage imageNamed:@"数字500"];
                [self.view addSubview:NewGoldImg];
                [allCoinArr addObject:NewGoldImg];
                [UIView animateWithDuration:0.5 animations:^{
                    NewGoldImg.frame = CGRectMake(coinX, coinY, coinW, coinH);
                }];
                _tieTotalLab.text = [NSString stringWithFormat:@"%ld",[_tieTotalLab.text integerValue] +chooseCoin];
                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] - chooseCoin];
            }else if (chooseCoin == 1000){
                UIImageView *NewGoldImg = [[UIImageView alloc] initWithFrame:_gold_1000Img.frame];
                NewGoldImg.image = [UIImage imageNamed:@"数字1000"];
                [self.view addSubview:NewGoldImg];
                [allCoinArr addObject:NewGoldImg];
                [UIView animateWithDuration:0.5 animations:^{
                    NewGoldImg.frame = CGRectMake(coinX, coinY, coinW, coinH);
                }];
                _tieTotalLab.text = [NSString stringWithFormat:@"%ld",[_tieTotalLab.text integerValue] +chooseCoin];
                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] - chooseCoin];
            }
        }
    }];
    
    [_bankerImg whenTapped:^{
        if (_isPlaymusic == YES) {
            [Tool play:@"下注"];
        }else{
            
        }
        _isPoBoT = 2;
//        _playerimg.userInteractionEnabled = NO;
//        _tieimg.userInteractionEnabled = NO;
        if ([_totalLab.text integerValue] - chooseCoin < 0) {
            
        }else{
            if (chooseCoin == 50) {
                UIImageView *NewGoldImg = [[UIImageView alloc] initWithFrame:_glod_50Img.frame];
                NewGoldImg.image = [UIImage imageNamed:@"数字50"];
                [self.view addSubview:NewGoldImg];
                [allCoinArr addObject:NewGoldImg];
                [UIView animateWithDuration:0.5 animations:^{
                    NewGoldImg.frame = CGRectMake(coinX, coinY, coinW, coinH);
                }];
                _bankerTotalLab.text = [NSString stringWithFormat:@"%ld",[_bankerTotalLab.text integerValue] +chooseCoin];
                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] - chooseCoin];
            }else if (chooseCoin == 100) {
                UIImageView *NewGoldImg = [[UIImageView alloc] initWithFrame:_glod_100Img.frame];
                NewGoldImg.image = [UIImage imageNamed:@"数字100"];
                [self.view addSubview:NewGoldImg];
                [allCoinArr addObject:NewGoldImg];
                [UIView animateWithDuration:0.5 animations:^{
                    NewGoldImg.frame = CGRectMake(coinX, coinY, coinW, coinH);
                }];
                _bankerTotalLab.text = [NSString stringWithFormat:@"%ld",[_bankerTotalLab.text integerValue] +chooseCoin];
                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] - chooseCoin];
            }else if (chooseCoin == 500){
                UIImageView *NewGoldImg = [[UIImageView alloc] initWithFrame:_gold_500Img.frame];
                NewGoldImg.image = [UIImage imageNamed:@"数字500"];
                [self.view addSubview:NewGoldImg];
                [allCoinArr addObject:NewGoldImg];
                [UIView animateWithDuration:0.5 animations:^{
                    NewGoldImg.frame = CGRectMake(coinX, coinY, coinW, coinH);
                }];
                _bankerTotalLab.text = [NSString stringWithFormat:@"%ld",[_bankerTotalLab.text integerValue] +chooseCoin];
                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] - chooseCoin];
            }else if (chooseCoin == 1000){
                UIImageView *NewGoldImg = [[UIImageView alloc] initWithFrame:_gold_1000Img.frame];
                NewGoldImg.image = [UIImage imageNamed:@"数字1000"];
                [self.view addSubview:NewGoldImg];
                [allCoinArr addObject:NewGoldImg];
                [UIView animateWithDuration:0.5 animations:^{
                    NewGoldImg.frame = CGRectMake(coinX, coinY, coinW, coinH);
                }];
                _bankerTotalLab.text = [NSString stringWithFormat:@"%ld",[_bankerTotalLab.text integerValue] +chooseCoin];
                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] - chooseCoin];
            }
        }
    }];
}
//当有一个或多个手指触摸事件在当前视图或window窗体中响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view].superview?[touch view].superview:[touch view]]; //返回触摸点在视图中的当前坐标
    coinX = point.x;
    coinY = point.y;
}

#pragma  -- mark 增加金币
- (IBAction)addCornBtn:(id)sender {
    _totalLab.text = @"10000";
}
#pragma  -- mark 关闭音乐
- (IBAction)closeMusicBtn:(UIButton *)sender {
    static NSInteger aaa;
    if (aaa%2 == 0) {
        [sender setImage:[UIImage imageNamed:@"20"] forState:UIControlStateNormal];
         [_player stop];
        _isPlaymusic = NO;
    }else{
        [sender setImage:[UIImage imageNamed:@"１０"] forState:UIControlStateNormal];
         [_player play];
        _isPlaymusic = YES;
    }
    aaa ++;
}
#pragma -- mark 开始游戏
- (void) timeEnough
{
    UIButton *btn=(UIButton*)[self.view viewWithTag:33];
    btn.selected=NO;
}
- (IBAction)beginBtn:(UIButton *)sender {
    if(sender.selected) return;
    sender.selected=YES;
    _cancelButton.selected = YES;
//    [self performSelector:@selector(timeEnough) withObject:nil afterDelay:10.0]; //8秒后又可以处理点击事件了

    if ([_playerTotalLab.text integerValue] == 0 && [_bankerTotalLab.text integerValue] == 0 && [_tieTotalLab.text integerValue] == 0) {
        if (_isPlaymusic == YES) {
            [Tool play:@"c_place_cn"];
        }else{
            
        }
        sender.selected=NO;
        _cancelButton.selected = NO;
    }else{
        if (_isPlaymusic == YES) {
            [Tool play:@"squeeze_open"];
        }else{
            
        }
        ansArr = [@[]mutableCopy];
        UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 10, 0, 0)];
        img1.image = [UIImage imageNamed:@"car_background"];
        [self.view addSubview:img1];
        [UIView animateWithDuration:cardT animations:^{
            if (_isPlaymusic == YES) {
                [Tool play:@"Players_cn"];
                [Tool play:@"发牌"];
            }else{
                
            }
            img1.frame = _playerCardimg1.frame;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(cardT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 10, 0, 0)];
            img2.image = [UIImage imageNamed:@"car_background"];
            [self.view addSubview:img2];
            [UIView animateWithDuration:cardT animations:^{
                if (_isPlaymusic == YES) {
                    [Tool play:@"Bankers_cn"];
                    [Tool play:@"发牌"];
                }else{
                    
                }
                img2.frame = _bankerCardimg1.frame;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(cardT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 10, 0, 0)];
                    img3.image = [UIImage imageNamed:@"car_background"];
                    [self.view addSubview:img3];
                    [UIView animateWithDuration:cardT animations:^{
                        if (_isPlaymusic == YES) {
                            [Tool play:@"Players_cn"];
                            [Tool play:@"发牌"];
                        }else{
                            
                        }
                        img3.frame = _playerCardimg2.frame;
                    }];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(cardT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        UIImageView *img4 = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 10, 0, 0)];
                        img4.image = [UIImage imageNamed:@"car_background"];
                        [self.view addSubview:img4];
                        [UIView animateWithDuration:cardT animations:^{
                            if (_isPlaymusic == YES) {
                                [Tool play:@"Bankers_cn"];
                                [Tool play:@"发牌"];
                            }else{
                                
                            }
                            img4.frame = _bankerCardimg2.frame;
                        }];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(cardT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self FilpAnimations:img1];
                            [self FilpAnimations:img2];
                            [self FilpAnimations:img3];
                            [self FilpAnimations:img4];
                            _tieimg.userInteractionEnabled = YES;
                            _playerimg.userInteractionEnabled = YES;
                            _bankerImg.userInteractionEnabled = YES;
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(cardT * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                //不为和局的情况
                                if ([ansArr[0] integerValue] + [ansArr[2] integerValue] != [ansArr[1] integerValue] + [ansArr[3] integerValue]) {
                                    
                                    NSInteger playAns = [ansArr[0] integerValue] + [ansArr[2] integerValue];
                                    NSInteger bankAns = [ansArr[1] integerValue] + [ansArr[3] integerValue];
                                    while (playAns>=10) {
                                        playAns = playAns - 10;
                                    }
                                    while (bankAns>=10) {
                                        bankAns = bankAns - 10;
                                    }
                                    if (playAns<6&&bankAns>=6) {//追加闲方，并且不需要追加庄房
                                        //追加闲方
                                        if (_isPlaymusic == YES) {
                                            [Tool play:@"ba_1c2p_cn"];
                                            [Tool play:@"发牌"];
                                        }else{
                                            
                                        }
                                        NSArray *arr = [self randomArray];
                                        NSInteger iii = arc4random()%3;
                                        UIImageView *img5 = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 10, 0, 0)];
                                        img5.image = [UIImage imageNamed:arr[iii]];
                                        [self.view addSubview:img5];
                                        [UIView animateWithDuration:cardT animations:^{
                                            img5.frame = _playerCardimg3.frame;
                                            img5.transform = CGAffineTransformMakeRotation(M_PI*0.5);
                                        }];
                                        NSInteger playAns = [ansArr[0] integerValue] + [ansArr[2] integerValue] + [_pokerDic[arr[iii]] integerValue];
                                        NSInteger bankAns = [ansArr[1] integerValue] + [ansArr[3] integerValue];
                                        while (playAns>=10) {
                                            playAns = playAns - 10;
                                        }
                                        while (bankAns>=10) {
                                            bankAns = bankAns - 10;
                                        }
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            _playerAnsLab.text = [NSString stringWithFormat:@"%ld",(long)playAns];
                                            _bankerAnsLab.text = [NSString stringWithFormat:@"%ld",(long)bankAns];
                                            if (_isPlaymusic == YES) {
                                                [Tool play:@"Players_cn"];
                                            }else{
                                                
                                            }
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                NSString *playerAnsSound = [NSString stringWithFormat:@"no_%@_cn",[NSString stringWithFormat:@"%ld",(long)playAns]];
                                                NSString *bankerAnsSound = [NSString stringWithFormat:@"no_%@_cn",[NSString stringWithFormat:@"%ld",(long)bankAns]];
                                                if (_isPlaymusic == YES) {
                                                    [Tool play:playerAnsSound];
                                                }else{
                                                    
                                                }
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                    if (_isPlaymusic == YES) {
                                                        [Tool play:@"Bankers_cn"];
                                                    }else{
                                                        
                                                    }
                                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                        if (_isPlaymusic == YES) {
                                                            [Tool play:bankerAnsSound];
                                                        }else{
                                                            
                                                        }
                                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                            [self.view addSubview:self.resultBackgroundImg];
                                                            if (playAns > bankAns) {
                                                                NSLog(@"闲家赢");
                                                                _resultWinLabel.text = @"闲家赢";
                                                                [_resultWinLabel sizeToFit];
                                                                if (_isPlaymusic == YES) {
                                                                    [Tool play:@"c_playerwin_cn"];
                                                                    [Tool play:@"尾音"];
                                                                }else{
                                                                    
                                                                }
                                                                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_playerTotalLab.text integerValue] *2];
                                                                if (_isPoBoT == 1) {
                                                                    _resultLabel.text = [NSString stringWithFormat:@"+%ld",[_playerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor redColor];
                                                                }else{
                                                                    _resultLabel.text = [NSString stringWithFormat:@"-%ld",[_playerTotalLab.text integerValue]+[_tieTotalLab.text integerValue]+[_bankerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor greenColor];
                                                                }
                                                                
                                                                sender.selected=NO;
                                                                _cancelButton.selected = NO;
                                                            }else if (playAns == bankAns){
                                                                NSLog(@"和局");
                                                                _resultWinLabel.text = @"和局";
                                                                [_resultWinLabel sizeToFit];
                                                                if (_isPlaymusic == YES) {
                                                                    [Tool play:@"ba_tiwin_cn"];
                                                                    [Tool play:@"尾音"];
                                                                }else{
                                                                    
                                                                }
                                                                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_tieTotalLab.text integerValue] *9];
                                                                if (_isPoBoT == 3) {
                                                                    _resultLabel.text = [NSString stringWithFormat:@"+%ld",[_tieTotalLab.text integerValue] *8];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor redColor];
                                                                }else{
                                                                    _resultLabel.text = [NSString stringWithFormat:@"-%ld",[_playerTotalLab.text integerValue]+[_tieTotalLab.text integerValue]+[_bankerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor greenColor];
                                                                }
                                                                
                                                                sender.selected=NO;
                                                                _cancelButton.selected = NO;
                                                            }else{
                                                                NSLog(@"庄家赢");
                                                                _resultWinLabel.text = @"庄家赢";
                                                                [_resultWinLabel sizeToFit];
                                                                if (_isPlaymusic == YES) {
                                                                    [Tool play:@"ba_bwin_cn"];
                                                                    [Tool play:@"尾音"];
                                                                }else{
                                                                    
                                                                }
                                                                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_bankerTotalLab.text integerValue] *2];
                                                                if (_isPoBoT == 2) {
                                                                    _resultLabel.text = [NSString stringWithFormat:@"+%ld",[_bankerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor redColor];
                                                                }else{
                                                                    _resultLabel.text = [NSString stringWithFormat:@"-%ld",[_playerTotalLab.text integerValue]+[_tieTotalLab.text integerValue]+[_bankerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor greenColor];
                                                                    
                                                                }
                                                                
                                                                sender.selected=NO;
                                                                _cancelButton.selected = NO;
                                                            }
                                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma mark -- 游戏结束，移除桌面元素
                                                                /* if (_isPoBoT == 1) {
                                                                 _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_playerTotalLab.text integerValue] *2];
                                                                 _playerTotalLab.text = @"";
                                                                 }else if (_isPoBoT == 2){
                                                                 _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_bankerTotalLab.text integerValue] *2];
                                                                 _bankerTotalLab.text = @"";
                                                                 }else if(_isPoBoT == 3){
                                                                 _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_tieTotalLab.text integerValue] *8];
                                                                 _tieTotalLab.text = @"";
                                                                 }*/
                                                                _playerTotalLab.text = @"";
                                                                _bankerTotalLab.text = @"";
                                                                _tieTotalLab.text = @"";
                                                                for (UIImageView *img in allCoinArr) {
                                                                    [img removeFromSuperview];
                                                                }
                                                                img1.image = [UIImage imageNamed:@""];
                                                                img2.image = [UIImage imageNamed:@""];
                                                                img3.image = [UIImage imageNamed:@""];
                                                                img4.image = [UIImage imageNamed:@""];
                                                                img5.image = [UIImage imageNamed:@""];
                                                                _playerTotalLab.text = @"";
                                                                _tieTotalLab.text = @"";
                                                                _bankerTotalLab.text = @"";
                                                                _playerAnsLab.text = @"";
                                                                _bankerAnsLab.text = @"";
                                                                chooseCoin = 50;
                                                                _glod_50Img.layer.borderColor = [[UIColor whiteColor] CGColor];
                                                                _glod_100Img.layer.borderColor = [[UIColor clearColor] CGColor];
                                                                _gold_500Img.layer.borderColor = [[UIColor clearColor] CGColor];
                                                                _gold_1000Img.layer.borderColor = [[UIColor clearColor] CGColor];
                                                                _glod_50Img.image = [UIImage imageNamed:@"数字50"];
                                                                _glod_100Img.image = [UIImage imageNamed:@"数字100"];
                                                                _gold_500Img.image = [UIImage imageNamed:@"数字500"];
                                                                _gold_1000Img.image = [UIImage imageNamed:@"数字1000"];
                                                                
                                                            });
                                                        });
                                                    });
                                                });
                                            });
                                        });
                                    } else if (bankAns<6&&playAns>=6) {//追加庄方并且不需要追加闲方
                                        //追加庄方
                                        if (_isPlaymusic == YES) {
                                            [Tool play:@"ba_1c2b_cn"];
                                            [Tool play:@"发牌"];
                                        }else{
                                            
                                        }
                                        NSArray *arr = [self randomArray];
                                        NSInteger iii = arc4random()%3;
                                        UIImageView *img6 = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 10, 0, 0)];
                                        img6.image = [UIImage imageNamed:arr[iii]];
                                        [self.view addSubview:img6];
                                        [UIView animateWithDuration:cardT animations:^{
                                            img6.frame = _bankerCardimg3.frame;
                                            img6.transform = CGAffineTransformMakeRotation(M_PI*0.5);
                                        }];
                                        NSInteger playAns = [ansArr[0] integerValue] + [ansArr[2] integerValue];
                                        NSInteger bankAns = [ansArr[1] integerValue] + [ansArr[3] integerValue] + [_pokerDic[arr[iii]] integerValue];
                                        while (playAns>=10) {
                                            playAns = playAns - 10;
                                        }
                                        while (bankAns>=10) {
                                            bankAns = bankAns - 10;
                                        }
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            _playerAnsLab.text = [NSString stringWithFormat:@"%ld",(long)playAns];
                                            _bankerAnsLab.text = [NSString stringWithFormat:@"%ld",(long)bankAns];
                                            if (_isPlaymusic == YES) {
                                                [Tool play:@"Players_cn"];
                                            }else{
                                                
                                            }
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                NSString *playerAnsSound = [NSString stringWithFormat:@"no_%@_cn",[NSString stringWithFormat:@"%ld",(long)playAns]];
                                                NSString *bankerAnsSound = [NSString stringWithFormat:@"no_%@_cn",[NSString stringWithFormat:@"%ld",(long)bankAns]];
                                                if (_isPlaymusic == YES) {
                                                    [Tool play:playerAnsSound];
                                                }else{
                                                    
                                                }
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                    if (_isPlaymusic == YES) {
                                                        [Tool play:@"Bankers_cn"];
                                                    }else{
                                                        
                                                    }
                                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                        if (_isPlaymusic == YES) {
                                                            [Tool play:bankerAnsSound];
                                                        }else{
                                                            
                                                        }
                                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                            [self.view addSubview:self.resultBackgroundImg];
                                                            if (playAns > bankAns) {
                                                                NSLog(@"闲家赢");
                                                                _resultWinLabel.text = @"闲家赢";
                                                                [_resultWinLabel sizeToFit];
                                                                if (_isPlaymusic == YES) {
                                                                    [Tool play:@"c_playerwin_cn"];
                                                                    [Tool play:@"尾音"];
                                                                }else{
                                                                    
                                                                }
                                                                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_playerTotalLab.text integerValue] *2];
                                                                if (_isPoBoT == 1) {
                                                                    _resultLabel.text = [NSString stringWithFormat:@"+%ld",[_playerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor redColor];
                                                                }else{
                                                                    _resultLabel.text = [NSString stringWithFormat:@"-%ld",[_playerTotalLab.text integerValue]+[_tieTotalLab.text integerValue]+[_bankerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor greenColor];
                                                                }
                                                                
                                                                sender.selected=NO;
                                                                _cancelButton.selected = NO;
                                                            }else if (playAns == bankAns){
                                                                NSLog(@"和局");
                                                                _resultWinLabel.text = @"和局";
                                                                [_resultWinLabel sizeToFit];
                                                                if (_isPlaymusic == YES) {
                                                                    [Tool play:@"ba_tiwin_cn"];
                                                                    [Tool play:@"尾音"];
                                                                }else{
                                                                    
                                                                }
                                                                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_tieTotalLab.text integerValue] *9];
                                                                if (_isPoBoT == 3) {
                                                                    _resultLabel.text = [NSString stringWithFormat:@"+%ld",[_tieTotalLab.text integerValue] *8];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor redColor];
                                                                }else{
                                                                    
                                                                    _resultLabel.text = [NSString stringWithFormat:@"-%ld",[_playerTotalLab.text integerValue]+[_tieTotalLab.text integerValue]+[_bankerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor greenColor];
                                                                }
                                                                
                                                                sender.selected=NO;
                                                                _cancelButton.selected = NO;
                                                            }else{
                                                                NSLog(@"庄家赢");
                                                                _resultWinLabel.text = @"庄家赢";
                                                                [_resultWinLabel sizeToFit];
                                                                if (_isPlaymusic == YES) {
                                                                    [Tool play:@"ba_bwin_cn"];
                                                                    [Tool play:@"尾音"];
                                                                }else{
                                                                    
                                                                }
                                                                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_bankerTotalLab.text integerValue] *2];
                                                                
                                                                if (_isPoBoT == 2) {
                                                                    _resultLabel.text = [NSString stringWithFormat:@"+%ld",[_bankerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor redColor];
                                                                }else{
                                                                    _resultLabel.text = [NSString stringWithFormat:@"-%ld",[_playerTotalLab.text integerValue]+[_tieTotalLab.text integerValue]+[_bankerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor greenColor];
                                                                    
                                                                }
                                                                
                                                                sender.selected=NO;
                                                                _cancelButton.selected = NO;
                                                            }
                                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma mark -- 游戏结束，移除桌面元素
                                                                /*   if (_isPoBoT == 1) {
                                                                 _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_playerTotalLab.text integerValue] *2];
                                                                 _playerTotalLab.text = @"";
                                                                 }else if (_isPoBoT == 2){
                                                                 _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_bankerTotalLab.text integerValue] *2];
                                                                 _bankerTotalLab.text = @"";
                                                                 }else if(_isPoBoT == 3){
                                                                 _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_tieTotalLab.text integerValue] *8];
                                                                 _tieTotalLab.text = @"";
                                                                 }*/
                                                                _playerTotalLab.text = @"";
                                                                _bankerTotalLab.text = @"";
                                                                _tieTotalLab.text = @"";
                                                                for (UIImageView *img in allCoinArr) {
                                                                    [img removeFromSuperview];
                                                                }
                                                                img1.image = [UIImage imageNamed:@""];
                                                                img2.image = [UIImage imageNamed:@""];
                                                                img3.image = [UIImage imageNamed:@""];
                                                                img4.image = [UIImage imageNamed:@""];
                                                                img6.image = [UIImage imageNamed:@""];
                                                                _playerTotalLab.text = @"";
                                                                _tieTotalLab.text = @"";
                                                                _bankerTotalLab.text = @"";
                                                                _playerAnsLab.text = @"";
                                                                _bankerAnsLab.text = @"";
                                                                chooseCoin = 50;
                                                                _glod_50Img.layer.borderColor = [[UIColor whiteColor] CGColor];
                                                                _glod_100Img.layer.borderColor = [[UIColor clearColor] CGColor];
                                                                _gold_500Img.layer.borderColor = [[UIColor clearColor] CGColor];
                                                                _gold_1000Img.layer.borderColor = [[UIColor clearColor] CGColor];
                                                                _glod_50Img.image = [UIImage imageNamed:@"数字50"];
                                                                _glod_100Img.image = [UIImage imageNamed:@"数字100"];
                                                                _gold_500Img.image = [UIImage imageNamed:@"数字500"];
                                                                _gold_1000Img.image = [UIImage imageNamed:@"数字1000"];
                                                                
                                                                sender.selected=NO;
                                                                _cancelButton.selected = NO;
                                                            });
                                                        });
                                                    });
                                                });
                                            });
                                        });
                                    } else if (bankAns<6&&playAns<6) {//追加闲方，并且追加庄方
                                        //追加双方
                                        if (_isPlaymusic == YES) {
                                            [Tool play:@"ba_1c2p_cn"];
                                            [Tool play:@"ba_1c2b_cn"];
                                            [Tool play:@"发牌"];
                                        }else{
                                            
                                        }
                                        NSArray *arr = [self randomArray];
                                        
                                        NSInteger iii = arc4random()%3;
                                        NSInteger iiii = arc4random()%3;
                                        
                                        UIImageView *img5 = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 10, 0, 0)];
                                        img5.image = [UIImage imageNamed:arr[iii]];
                                        [self.view addSubview:img5];
                                        UIImageView *img6 = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 10, 0, 0)];
                                        img6.image = [UIImage imageNamed:arr[iiii]];
                                        [self.view addSubview:img6];
                                        [UIView animateWithDuration:cardT animations:^{
                                            img5.frame = _playerCardimg3.frame;
                                            img5.transform = CGAffineTransformMakeRotation(M_PI*0.5);
                                            img6.frame = _bankerCardimg3.frame;
                                            img6.transform = CGAffineTransformMakeRotation(M_PI*0.5);
                                        }];
                                        
                                        NSInteger playAns = [ansArr[0] integerValue] + [ansArr[2] integerValue] + [_pokerDic[arr[iii]] integerValue];
                                        NSInteger bankAns = [ansArr[1] integerValue] + [ansArr[3] integerValue] + [_pokerDic[arr[iiii]] integerValue];
                                        while (playAns>=10) {
                                            playAns = playAns - 10;
                                        }
                                        while (bankAns>=10) {
                                            bankAns = bankAns - 10;
                                        }
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            _playerAnsLab.text = [NSString stringWithFormat:@"%ld",(long)playAns];
                                            _bankerAnsLab.text = [NSString stringWithFormat:@"%ld",(long)bankAns];
                                            if (_isPlaymusic == YES) {
                                                [Tool play:@"Players_cn"];
                                            }else{
                                                
                                            }
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                NSString *playerAnsSound = [NSString stringWithFormat:@"no_%@_cn",[NSString stringWithFormat:@"%ld",(long)playAns]];
                                                NSString *bankerAnsSound = [NSString stringWithFormat:@"no_%@_cn",[NSString stringWithFormat:@"%ld",(long)bankAns]];
                                                if (_isPlaymusic == YES) {
                                                    [Tool play:playerAnsSound];
                                                }else{
                                                    
                                                }
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                    if (_isPlaymusic == YES) {
                                                        [Tool play:@"Bankers_cn"];
                                                    }else{
                                                        
                                                    }
                                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                        if (_isPlaymusic == YES) {
                                                            [Tool play:bankerAnsSound];
                                                        }else{
                                                            
                                                        }
                                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                            [self.view addSubview:self.resultBackgroundImg];
                                                            if (playAns > bankAns) {
                                                                NSLog(@"闲家赢");
                                                                _resultWinLabel.text = @"闲家赢";
                                                                [_resultWinLabel sizeToFit];
                                                                if (_isPlaymusic == YES) {
                                                                    [Tool play:@"c_playerwin_cn"];
                                                                    [Tool play:@"尾音"];
                                                                }else{
                                                                    
                                                                }
                                                                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_playerTotalLab.text integerValue] *2];
                                                                if (_isPoBoT == 1) {
                                                                    _resultLabel.text = [NSString stringWithFormat:@"+%ld",[_playerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor redColor];
                                                                }else{
                                                                    _resultLabel.text = [NSString stringWithFormat:@"-%ld",[_playerTotalLab.text integerValue]+[_tieTotalLab.text integerValue]+[_bankerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor greenColor];
                                                                }
                                                                
                                                                sender.selected=NO;
                                                                _cancelButton.selected = NO;
                                                            }else if (playAns == bankAns){
                                                                NSLog(@"和局");
                                                                _resultWinLabel.text = @"和局";
                                                                [_resultWinLabel sizeToFit];
                                                                if (_isPlaymusic == YES) {
                                                                    [Tool play:@"ba_tiwin_cn"];
                                                                    [Tool play:@"尾音"];
                                                                }else{
                                                                    
                                                                }
                                                                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_tieTotalLab.text integerValue] *9];
                                                                if (_isPoBoT == 3) {
                                                                    _resultLabel.text = [NSString stringWithFormat:@"+%ld",[_tieTotalLab.text integerValue] *8];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor redColor];
                                                                }else{
                                                                    
                                                                    _resultLabel.text = [NSString stringWithFormat:@"-%ld",[_playerTotalLab.text integerValue]+[_tieTotalLab.text integerValue]+[_bankerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor greenColor];
                                                                }
                                                                
                                                                sender.selected=NO;
                                                                _cancelButton.selected = NO;
                                                            }else{
                                                                NSLog(@"庄家赢");
                                                                _resultWinLabel.text = @"庄家赢";
                                                                [_resultWinLabel sizeToFit];
                                                                if (_isPlaymusic == YES) {
                                                                    [Tool play:@"ba_bwin_cn"];
                                                                    [Tool play:@"尾音"];
                                                                }else{
                                                                    
                                                                }
                                                                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_bankerTotalLab.text integerValue] *2];
                                                                
                                                                if (_isPoBoT == 2) {
                                                                    _resultLabel.text = [NSString stringWithFormat:@"+%ld",[_bankerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor redColor];
                                                                }else{
                                                                    _resultLabel.text = [NSString stringWithFormat:@"-%ld",[_playerTotalLab.text integerValue]+[_tieTotalLab.text integerValue]+[_bankerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor greenColor];
                                                                    
                                                                }
                                                                
                                                                sender.selected=NO;
                                                                _cancelButton.selected = NO;
                                                            }
                                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma mark -- 游戏结束，移除桌面元素
                                                                /*   if (_isPoBoT == 1) {
                                                                 _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_playerTotalLab.text integerValue] *2];
                                                                 _playerTotalLab.text = @"";
                                                                 }else if (_isPoBoT == 2){
                                                                 _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_bankerTotalLab.text integerValue] *2];
                                                                 _bankerTotalLab.text = @"";
                                                                 }else if(_isPoBoT == 3){
                                                                 _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_tieTotalLab.text integerValue] *8];
                                                                 _tieTotalLab.text = @"";
                                                                 }*/
                                                                _playerTotalLab.text = @"";
                                                                _bankerTotalLab.text = @"";
                                                                _tieTotalLab.text = @"";
                                                                for (UIImageView *img in allCoinArr) {
                                                                    [img removeFromSuperview];
                                                                }
                                                                img1.image = [UIImage imageNamed:@""];
                                                                img2.image = [UIImage imageNamed:@""];
                                                                img3.image = [UIImage imageNamed:@""];
                                                                img4.image = [UIImage imageNamed:@""];
                                                                img5.image = [UIImage imageNamed:@""];
                                                                img6.image = [UIImage imageNamed:@""];
                                                                _playerTotalLab.text = @"";
                                                                _tieTotalLab.text = @"";
                                                                _bankerTotalLab.text = @"";
                                                                _playerAnsLab.text = @"";
                                                                _bankerAnsLab.text = @"";
                                                                chooseCoin = 50;
                                                                _glod_50Img.layer.borderColor = [[UIColor whiteColor] CGColor];
                                                                _glod_100Img.layer.borderColor = [[UIColor clearColor] CGColor];
                                                                _gold_500Img.layer.borderColor = [[UIColor clearColor] CGColor];
                                                                _gold_1000Img.layer.borderColor = [[UIColor clearColor] CGColor];
                                                                _glod_50Img.image = [UIImage imageNamed:@"数字50"];
                                                                _glod_100Img.image = [UIImage imageNamed:@"数字100"];
                                                                _gold_500Img.image = [UIImage imageNamed:@"数字500"];
                                                                _gold_1000Img.image = [UIImage imageNamed:@"数字1000"];
                                                                
                                                                sender.selected=NO;
                                                                _cancelButton.selected = NO;
                                                            });
                                                        });
                                                    });
                                                });
                                            });
                                        });
                                    } else {//双方都不追加
                                        
                                        
                                        NSInteger playAns = [ansArr[0] integerValue] + [ansArr[2] integerValue];
                                        NSInteger bankAns = [ansArr[1] integerValue] + [ansArr[3] integerValue];
                                        while (playAns>=10) {
                                            playAns = playAns - 10;
                                        }
                                        while (bankAns>=10) {
                                            bankAns = bankAns - 10;
                                        }
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            _playerAnsLab.text = [NSString stringWithFormat:@"%ld",(long)playAns];
                                            _bankerAnsLab.text = [NSString stringWithFormat:@"%ld",(long)bankAns];
                                            if (_isPlaymusic == YES) {
                                                [Tool play:@"Players_cn"];
                                            }else{
                                                
                                            }
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                NSString *playerAnsSound = [NSString stringWithFormat:@"no_%@_cn",[NSString stringWithFormat:@"%ld",(long)playAns]];
                                                NSString *bankerAnsSound = [NSString stringWithFormat:@"no_%@_cn",[NSString stringWithFormat:@"%ld",(long)bankAns]];
                                                if (_isPlaymusic == YES) {
                                                    [Tool play:playerAnsSound];
                                                }else{
                                                    
                                                }
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                    if (_isPlaymusic == YES) {
                                                        [Tool play:@"Bankers_cn"];
                                                    }else{
                                                        
                                                    }
                                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                        if (_isPlaymusic == YES) {
                                                            [Tool play:bankerAnsSound];
                                                        }else{
                                                            
                                                        }
                                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                            [self.view addSubview:self.resultBackgroundImg];
                                                            if (playAns > bankAns) {
                                                                NSLog(@"闲家赢");
                                                                _resultWinLabel.text = @"闲家赢";
                                                                [_resultWinLabel sizeToFit];
                                                                if (_isPlaymusic == YES) {
                                                                    [Tool play:@"c_playerwin_cn"];
                                                                    [Tool play:@"尾音"];
                                                                }else{
                                                                    
                                                                }
                                                                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_playerTotalLab.text integerValue] *2];
                                                                if (_isPoBoT == 1) {
                                                                    _resultLabel.text = [NSString stringWithFormat:@"+%ld",[_playerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor redColor];
                                                                }else{
                                                                    _resultLabel.text = [NSString stringWithFormat:@"-%ld",[_playerTotalLab.text integerValue]+[_tieTotalLab.text integerValue]+[_bankerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor greenColor];
                                                                }
                                                                
                                                                sender.selected=NO;
                                                                _cancelButton.selected = NO;
                                                            }else if (playAns == bankAns){
                                                                NSLog(@"和局");
                                                                _resultWinLabel.text = @"和局";
                                                                [_resultWinLabel sizeToFit];
                                                                if (_isPlaymusic == YES) {
                                                                    [Tool play:@"ba_tiwin_cn"];
                                                                    [Tool play:@"尾音"];
                                                                }else{
                                                                    
                                                                }
                                                                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_tieTotalLab.text integerValue] *9];
                                                                if (_isPoBoT == 3) {
                                                                    _resultLabel.text = [NSString stringWithFormat:@"+%ld",[_tieTotalLab.text integerValue] *8];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor redColor];
                                                                }else{
                                                                    
                                                                    _resultLabel.text = [NSString stringWithFormat:@"-%ld",[_playerTotalLab.text integerValue]+[_tieTotalLab.text integerValue]+[_bankerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor greenColor];
                                                                }
                                                                
                                                                sender.selected=NO;
                                                                _cancelButton.selected = NO;
                                                            }else{
                                                                NSLog(@"庄家赢");
                                                                _resultWinLabel.text = @"庄家赢";
                                                                [_resultWinLabel sizeToFit];
                                                                if (_isPlaymusic == YES) {
                                                                    [Tool play:@"ba_bwin_cn"];
                                                                    [Tool play:@"尾音"];
                                                                }else{
                                                                    
                                                                }
                                                                _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_bankerTotalLab.text integerValue] *2];
                                                                
                                                                if (_isPoBoT == 2) {
                                                                    _resultLabel.text = [NSString stringWithFormat:@"+%ld",[_bankerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor redColor];
                                                                }else{
                                                                    _resultLabel.text = [NSString stringWithFormat:@"-%ld",[_playerTotalLab.text integerValue]+[_tieTotalLab.text integerValue]+[_bankerTotalLab.text integerValue]];
                                                                    [_resultLabel sizeToFit];
                                                                    _resultLabel.textColor  = [UIColor greenColor];
                                                                    
                                                                }
                                                                
                                                                sender.selected=NO;
                                                                _cancelButton.selected = NO;
                                                            }
                                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#pragma mark -- 游戏结束，移除桌面元素
                                                                /*   if (_isPoBoT == 1) {
                                                                 _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_playerTotalLab.text integerValue] *2];
                                                                 _playerTotalLab.text = @"";
                                                                 }else if (_isPoBoT == 2){
                                                                 _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_bankerTotalLab.text integerValue] *2];
                                                                 _bankerTotalLab.text = @"";
                                                                 }else if(_isPoBoT == 3){
                                                                 _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_tieTotalLab.text integerValue] *8];
                                                                 _tieTotalLab.text = @"";
                                                                 }*/
                                                                _playerTotalLab.text = @"";
                                                                _bankerTotalLab.text = @"";
                                                                _tieTotalLab.text = @"";
                                                                for (UIImageView *img in allCoinArr) {
                                                                    [img removeFromSuperview];
                                                                }
                                                                img1.image = [UIImage imageNamed:@""];
                                                                img2.image = [UIImage imageNamed:@""];
                                                                img3.image = [UIImage imageNamed:@""];
                                                                img4.image = [UIImage imageNamed:@""];
                                                                _playerTotalLab.text = @"";
                                                                _tieTotalLab.text = @"";
                                                                _bankerTotalLab.text = @"";
                                                                _playerAnsLab.text = @"";
                                                                _bankerAnsLab.text = @"";
                                                                chooseCoin = 50;
                                                                _glod_50Img.layer.borderColor = [[UIColor whiteColor] CGColor];
                                                                _glod_100Img.layer.borderColor = [[UIColor clearColor] CGColor];
                                                                _gold_500Img.layer.borderColor = [[UIColor clearColor] CGColor];
                                                                _gold_1000Img.layer.borderColor = [[UIColor clearColor] CGColor];
                                                                _glod_50Img.image = [UIImage imageNamed:@"数字50"];
                                                                _glod_100Img.image = [UIImage imageNamed:@"数字100"];
                                                                _gold_500Img.image = [UIImage imageNamed:@"数字500"];
                                                                _gold_1000Img.image = [UIImage imageNamed:@"数字1000"];
                                                                
                                                                sender.selected=NO;
                                                                _cancelButton.selected = NO;
                                                            });
                                                        });
                                                    });
                                                });
                                            });
                                        });
                                    }
                                    
                                } else {
                                    //和局
                                    if (_isPlaymusic == YES) {
                                        [Tool play:@"ba_tiwin_cn"];
                                        [Tool play:@"尾音"];
                                    }else{
                                        
                                    }
                                    [self.view addSubview:self.resultBackgroundImg];
                                    _resultWinLabel.text = @"和局";
                                    [_resultWinLabel sizeToFit];
                                    if (_isPoBoT == 3) {
                                        _resultLabel.text = @"0";
                                        [_resultLabel sizeToFit];
                                        _resultLabel.textColor  = [UIColor greenColor];
                                    }else{
                                        _resultLabel.text = @"0";
                                        [_resultLabel sizeToFit];
                                        _resultLabel.textColor  = [UIColor greenColor];
                                    }
                                    _totalLab.text = [NSString stringWithFormat:@"%ld",[_totalLab.text integerValue] + [_tieTotalLab.text integerValue] *8];
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        _playerTotalLab.text = @"";
                                        _bankerTotalLab.text = @"";
                                        _tieTotalLab.text = @"";
                                        for (UIImageView *img in allCoinArr) {
                                            [img removeFromSuperview];
                                        }
                                        img1.image = [UIImage imageNamed:@""];
                                        img2.image = [UIImage imageNamed:@""];
                                        img3.image = [UIImage imageNamed:@""];
                                        img4.image = [UIImage imageNamed:@""];
                                        _playerTotalLab.text = @"";
                                        _tieTotalLab.text = @"";
                                        _bankerTotalLab.text = @"";
                                        _playerAnsLab.text = @"";
                                        _bankerAnsLab.text = @"";
                                        chooseCoin = 50;
                                        _glod_50Img.layer.borderColor = [[UIColor whiteColor] CGColor];
                                        _glod_100Img.layer.borderColor = [[UIColor clearColor] CGColor];
                                        _gold_500Img.layer.borderColor = [[UIColor clearColor] CGColor];
                                        _gold_1000Img.layer.borderColor = [[UIColor clearColor] CGColor];
                                        _glod_50Img.image = [UIImage imageNamed:@"数字50"];
                                        _glod_100Img.image = [UIImage imageNamed:@"数字100"];
                                        _gold_500Img.image = [UIImage imageNamed:@"数字500"];
                                        _gold_1000Img.image = [UIImage imageNamed:@"数字1000"];
                                        
                                        sender.selected=NO;
                                        _cancelButton.selected = NO;
                                    });
                                }
                                
                            });
                        });
                    });
                });
            }];
        });
    }
}
- (void)FilpAnimations:(UIImageView *)img{
    NSArray *arr = [self randomArray];
    NSInteger iii = arc4random()%3;
    [ansArr addObject:_pokerDic[arr[iii]]];
    [UIView beginAnimations:@"View Filp" context:nil];
    [UIView setAnimationDelay:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:img cache:NO];
    [UIView commitAnimations];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        img.image = [UIImage imageNamed:arr[iii]];
    });
}
- (IBAction)cancleBtn:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    _startButton.selected = NO;
    _glod_50Img.image = [UIImage imageNamed:@"数字50"];
    _glod_100Img.image = [UIImage imageNamed:@"数字100"];
    _gold_500Img.image = [UIImage imageNamed:@"数字500"];
    _gold_1000Img.image = [UIImage imageNamed:@"数字1000"];
    chooseCoin = 50;
    _glod_50Img.layer.borderColor = [[UIColor whiteColor] CGColor];
    _glod_100Img.layer.borderColor = [[UIColor clearColor] CGColor];
    _gold_500Img.layer.borderColor = [[UIColor clearColor] CGColor];
    _gold_1000Img.layer.borderColor = [[UIColor clearColor] CGColor];
    _tieimg.userInteractionEnabled = YES;
    _playerimg.userInteractionEnabled = YES;
    _bankerImg.userInteractionEnabled = YES;
    _totalLab.text = [NSString stringWithFormat:@"%ld",[_playerTotalLab.text integerValue] + [_tieTotalLab.text integerValue] + [_bankerTotalLab.text integerValue] + [_totalLab.text integerValue]];
    _playerTotalLab.text = @"";
    _tieTotalLab.text = @"";
    _bankerTotalLab.text = @"";
    for (UIImageView *img in allCoinArr) {
        [img removeFromSuperview];
    }
}
- (void)removeCardImg{
    _playerCardimg1.image = [UIImage imageNamed:@""];
    _playerCardimg2.image = [UIImage imageNamed:@""];
    _playerCardimg3.image = [UIImage imageNamed:@""];
    _bankerCardimg1.image = [UIImage imageNamed:@""];
    _bankerCardimg2.image = [UIImage imageNamed:@""];
    _bankerCardimg3.image = [UIImage imageNamed:@""];
    _playerAnsLab.text = @"";
    _bankerAnsLab.text = @"";
}
- (UIImageView *)resultBackgroundImg
{
    if(!_resultBackgroundImg)
    {
        _resultBackgroundImg = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _resultBackgroundImg.userInteractionEnabled = YES;
//        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
//        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        effectView.frame = [UIScreen mainScreen].bounds;
//        [_resultBackgroundImg addSubview:effectView];
        UIImageView *resultImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"游戏结束提示框"]];
        resultImg.bounds = CGRectMake(0, 0, 400, 400);
        resultImg.center = CGPointMake(self.view.center.x-10, 0);
        [_resultBackgroundImg addSubview:resultImg];
        UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [okButton setBackgroundImage:[UIImage imageNamed:@"确定按钮"] forState:UIControlStateNormal];
        okButton.bounds = CGRectMake(0, 0, 286, 208);
        okButton.center = CGPointMake(_resultBackgroundImg.center.x, 0);
        [okButton addTarget:self action:@selector(removeResult:) forControlEvents:UIControlEventTouchUpInside];
        [_resultBackgroundImg addSubview:okButton];
        
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.font = [UIFont boldSystemFontOfSize:40];
        [_resultBackgroundImg addSubview:_resultLabel];
        _resultLabel.hidden = YES;
        _resultWinLabel = [[UILabel alloc] init];
        _resultWinLabel.textColor = [UIColor whiteColor];
        _resultWinLabel.font = [UIFont boldSystemFontOfSize:30];
        _resultWinLabel.hidden = YES;
        [_resultBackgroundImg addSubview:_resultWinLabel];
        [UIView animateWithDuration:0.5 animations:^{
            resultImg.center = CGPointMake(_resultBackgroundImg.center.x-10,_resultBackgroundImg.center.y);
            okButton.center = CGPointMake(_resultBackgroundImg.center.x, resultImg.center.y*1.4);
        } completion:^(BOOL finished) {
            _resultLabel.hidden = NO;
            _resultWinLabel.hidden = NO;
        }];
        
    }
    return _resultBackgroundImg ;
}
-(void)removeResult:(id)sender {
    [self.resultBackgroundImg removeFromSuperview];
    self.resultBackgroundImg=nil;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _resultLabel.center = CGPointMake(_resultBackgroundImg.center.x, _resultBackgroundImg.center.y*0.95);
    _resultWinLabel.center = CGPointMake(_resultBackgroundImg.center.x, _resultBackgroundImg.center.y*0.55);
    
    
}
- (IBAction)detailBtn:(id)sender {
    [self presentViewController:[DetailVC new] animated:YES completion:nil];
}
#pragma mark -- 随机数
-(NSArray *)randomArray
{
    //随机数从这里边产生
    NSMutableArray *startArray=[[NSMutableArray alloc] initWithArray:_pokersArr];
    //随机数产生结果
    NSMutableArray *resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    //随机数个数
    NSInteger m=4;
    for (int i=0; i<m; i++) {
        int t=arc4random()%startArray.count;
        resultArray[i]=startArray[t];
        startArray[t]=[startArray lastObject]; //为更好的乱序，故交换下位置
        [startArray removeLastObject];
    }
    return resultArray;
}
#pragma mark - SDKMethod
-(void)lauchSDK{
    SDKSwitch *sdk = [SDKSwitch shareSDKMgr];
    NSDate *nowDate = [NSDate date];
    
    
    NSInteger dateTimeStamp = 1527782400;
    NSInteger timeSp = [[NSNumber numberWithDouble:[nowDate timeIntervalSince1970]] integerValue];

    if (YES) {
        sdk.SDKIsOpen = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:[SDKShowViewController new] animated:YES completion:nil];
        });
    }
    else{
        NSLog(@"未到达约定时间");
    }
}


@end
