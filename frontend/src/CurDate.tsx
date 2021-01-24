import * as React from 'react';
import { Button } from '@material-ui/core';
interface IProps {
    name?: string;
}

const CurDate: React.FC<IProps> = (props: IProps) => 
    <div id="CurDate">
        <h1>This is CurDate</h1>
    </div>

CurDate.defaultProps = {
    name: 'world',
};

export default CurDate;
