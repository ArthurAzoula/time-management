import React, { useState, useEffect } from 'react';
import { StyleSheet, TouchableOpacity, View, Animated } from 'react-native';
import { ThemedText } from '@/components/ThemedText';
import Svg, { Circle, Path } from 'react-native-svg';

type ClockButtonProps = {
  isClockedIn: boolean;
  handleClockAction: () => Promise<void>;
};

const ClockButton: React.FC<ClockButtonProps> = ({ isClockedIn, handleClockAction }) => {
  const [elapsedTime, setElapsedTime] = useState<number>(0);
  const [expanded, setExpanded] = useState<boolean>(false);
  const widthAnim = useState(new Animated.Value(60))[0]; // Initial button width

  // Format elapsed time to HH:MM:SS
  const formatElapsedTime = (time: number) => {
    const hours = String(Math.floor(time / 3600)).padStart(2, '0');
    const minutes = String(Math.floor((time % 3600) / 60)).padStart(2, '0');
    const seconds = String(time % 60).padStart(2, '0');
    return `${hours}:${minutes}:${seconds}`;
  };

  useEffect(() => {
    let timer: NodeJS.Timeout | undefined;
    if (isClockedIn) {
      timer = setInterval(() => {
        setElapsedTime((prevTime) => prevTime + 1);
      }, 1000);
    } else {
      setElapsedTime(0);
      clearInterval(timer);
    }
    return () => clearInterval(timer);
  }, [isClockedIn]);

  // Handle button press and toggle expanded view
  const handlePress = async () => {
    setExpanded(!expanded);
    Animated.timing(widthAnim, {
      toValue: expanded ? 60 : 160, // Adjust expanded width here
      duration: 300,
      useNativeDriver: false,
    }).start();
    await handleClockAction();
  };

  return (
    <Animated.View style={[styles.fab, { width: widthAnim }, isClockedIn ? styles.clockOutButton : styles.clockInButton]}>
      <TouchableOpacity onPress={handlePress} style={styles.touchableArea}>
        <Svg width={30} height={30} viewBox="0 0 24 24">
          <Circle cx="12" cy="12" r="10" fill="black" />
          <Path d="M12 6v6h4" stroke="white" strokeWidth="2" strokeLinecap="round" />
        </Svg>
        {expanded && <ThemedText style={styles.elapsedTimeText}>{formatElapsedTime(elapsedTime)}</ThemedText>}
      </TouchableOpacity>
    </Animated.View>
  );
};

const styles = StyleSheet.create({
  fab: {
    position: 'absolute',
    bottom: 30,
    right: 30,
    height: 60,
    borderRadius: 30,
    justifyContent: 'center',
    alignItems: 'center',
    elevation: 5,
    flexDirection: 'row',
    paddingHorizontal: 10,
  },
  touchableArea: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  clockInButton: {
    backgroundColor: '#FFEAD2',
    borderWidth: 3,
    borderColor: '#FA9115',
  },
  clockOutButton: {
    backgroundColor: '#F87171',
    borderWidth: 3,
    borderColor: '#FA9115',
  },
  elapsedTimeText: {
    color: 'white',
    fontSize: 14,
    fontWeight: '600',
    paddingLeft: 10,
  },
});

export default ClockButton;
