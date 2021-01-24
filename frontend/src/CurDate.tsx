import * as React from 'react';
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
